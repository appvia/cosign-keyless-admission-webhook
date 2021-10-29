const express = require('express')
const app = express()
const port = 8080
const child_process = require('child_process')

app.use(express.json())

app.get('/', (req, res) => res.send('Listening for POSTs'))

app.post('/', async (req, res) => {
  const errors = []
  await Object.keys(req.body.request.object.metadata.annotations)
    .filter(k => k.includes("subject.cosign.sigstore.dev"))
    .forEach(async k => {
      req.body.request.object.metadata.annotations[k]
      const subject = req.body.request.object.metadata.annotations[k]
      const containerName = k.split("/")[1]
      const images = req.body.request.object.spec.containers.filter(container => container.name == containerName).map(container => container.image)
      await images.forEach(async image => {
        const response = child_process.spawnSync("cosign", ["verify", "-output", "json", image], {
          env: {
            COSIGN_EXPERIMENTAL: "1",
            PATH: "/usr/local/bin"
          }
        })
        if (response.status !== 0) {
          return errors.push(response.stderr)
        }
        var cosign
        try {
          cosign = JSON.parse(response.stdout.toString())
        }
        catch (_) {
          return errors.push(`Unable to parse response from cosign for ${image}`)
        }
        const signs = cosign.filter(sig => sig.critical.type === "cosign container image signature" && sig.optional.Subject === subject)
        if (signs.length === 0) {
          return errors.push(`${image} is not signed with the subject ${subject}`)
        }
      })
    })
  if (errors.length === 0) {
    return res.json(allowedTemplate(req.body.request.uid))
  }
  else {
    return res.json(notAllowedTemplate(req.body.request.uid, errors.join(", ")))
  }
})

const allowedTemplate = uid => {
  return {
    "apiVersion": "admission.k8s.io/v1",
    "kind": "AdmissionReview",
    "response": {
      "uid": uid,
      "allowed": true
    }
  }
}

const notAllowedTemplate = (uid, reason) => {
  return {
    "apiVersion": "admission.k8s.io/v1",
    "kind": "AdmissionReview",
    "response": {
      "uid": uid,
      "allowed": false,
      "status": {
        "code": 403,
        "message": reason
      }
    }
  }
}

app.listen(port, () =>
  console.log(`Listening at :${port}`)
)

if (process.env["CRT"] && process.env["KEY"]) {
  const https = require('https')
  const options = {
    key: process.env["KEY"],
    cert: process.env["CRT"]
  }
  https.createServer(options, app).listen(8443, () =>
    console.log(`Listening at :8443`)
  )
}