const express = require('express')
const app = express()
const port = 8080
const child_process = require('child_process')

app.use(express.json())

app.get('/', (req, res) => res.send('Listening for POSTs'))

app.post('/', async (req, res) => {
  const errors = []
  await req.body.request.object.spec.containers.forEach(container => {
    const image = container.image
    const subject = req.body.request.object.metadata?.annotations[`subject.cosign.sigstore.dev/${container.name}`]
    const issuer = req.body.request.object.metadata?.annotations[`issuer.cosign.sigstore.dev/${container.name}`]
    if (!subject && !issuer) {
      console.debug(`skipping checking ${image} has neither subject or issuer specified`)
      return
    }

    const response = child_process.spawnSync("cosign", ["verify", "--k8s-keychain", "--output", "json", image])
    if (response.status !== 0)
      return errors.push(response.stderr)

    var cosign
    try {
      cosign = JSON.parse(response.stdout.toString())
    }
    catch (_) {
      return errors.push(`Unable to parse response from cosign for ${image}`)
    }
    let signs = cosign
      .filter(sig => sig.critical.type === "cosign container image signature")

    if (subject)
      signs = signs.filter(sig => sig.optional.Subject === subject)

    if (issuer)
      signs = signs.filter(sig => sig.optional.Issuer === issuer)

    if (signs.length === 0) {
      if (subject && issuer)
        return errors.push(`${image} is not signed with the subject ${subject} AND issuer ${issuer}`)
      else if (subject)
        return errors.push(`${image} is not signed with the subject ${subject}`)
      else if (issuer)
        return errors.push(`${image} is not signed with the issuer ${issuer}`)
    }
  })
  if (errors.length === 0) {
    console.debug(`allowing ${req.body.request.object.metadata.namespace}/${req.body.request.object.metadata.name}`)
    return res.json(allowedTemplate(req.body.request.uid))
  } else {
    console.warn(errors.join(", "))
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