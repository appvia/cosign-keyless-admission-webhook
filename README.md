# Cosign keyless Kubernetes admission webhook

[![Build](https://github.com/appvia/cosign-keyless-admission-webhook/actions/workflows/ci.yml/badge.svg)](https://github.com/appvia/cosign-keyless-admission-webhook/actions/workflows/ci.yml)
[![Security Scanning](https://github.com/appvia/cosign-keyless-admission-webhook/actions/workflows/security.yml/badge.svg)](https://github.com/appvia/cosign-keyless-admission-webhook/actions/workflows/security.yml)
[![GitHub issues](https://img.shields.io/github/issues/appvia/cosign-keyless-admission-webhook.svg)](https://github.com/appvia/cosign-keyless-admission-webhook/issues)
[![GitHub forks](https://img.shields.io/github/forks/appvia/cosign-keyless-admission-webhook.svg)](https://github.com/appvia/cosign-keyless-admission-webhook/network)
[![GitHub stars](https://img.shields.io/github/stars/appvia/cosign-keyless-admission-webhook.svg)](https://github.com/appvia/cosign-keyless-admission-webhook/stargazers)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/appvia/cosign-keyless-admission-webhook/main/LICENSE)

> Kubernetes admission webhook that uses `cosign verify` to check the subject and issuer of the image matches what you expect

## Installation

```bash
# if you don't already have cert-manager
kubectl apply -f https://github.com/jetstack/cert-manager/releases/latest/download/cert-manager.yaml

kubectl apply -k https://github.com/appvia/cosign-keyless-admission-webhook
```

## Usage

In the pod spec you set an annotation(s) of `subject.cosign.sigstore.dev/CONTAINER_NAME`<sup>\*</sup> to the subject of the certificate and also set the `issuer.cosign.sigstore.dev/CONTAINER_NAME`<sup>\*</sup> to the Issuer.

> \*`CONTAINER_NAME` is the name of the container from your pod specification.

### Full example

```yaml
apiVersion: v1
kind: Pod
metadata:
  annotations:
    subject.cosign.sigstore.dev/demo: https://github.com/chrisns/cosign-keyless-demo/.github/workflows/ci.yml@refs/heads/main
    issuer.cosign.sigstore.dev/demo: https://token.actions.githubusercontent.com
    subject.cosign.sigstore.dev/demoagain: https://github.com/chrisns/cosign-keyless-demo/.github/workflows/ci.yml@refs/heads/main
    issuer.cosign.sigstore.dev/demoagain: https://token.actions.githubusercontent.com
  name: cosign-keyless-demo
spec:
  containers:
    - image: ghcr.io/chrisns/cosign-keyless-demo:latest
      name: demo
    - image: ghcr.io/chrisns/cosign-keyless-demo:latest
      name: demoagain
```

## 🚨🚨🚨 WHY THIS MAY NOT WORK FOR YOU 🚨🚨🚨

- Won't work, at least out the box with private registries or ones that just require authentication, you'll have to wire the credentials up to deployment's secrets
