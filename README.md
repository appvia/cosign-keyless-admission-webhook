# Cosign keyless Kubernetes admission webhook

[![Build](https://github.com/chrisns/cosign-keyless-github-admission-webhook/actions/workflows/ci.yml/badge.svg)](https://github.com/chrisns/cosign-keyless-github-admission-webhook/actions/workflows/ci.yml)
[![Security Scanning](https://github.com/chrisns/cosign-keyless-github-admission-webhook/actions/workflows/security.yml/badge.svg)](https://github.com/chrisns/cosign-keyless-github-admission-webhook/actions/workflows/security.yml)
[![GitHub issues](https://img.shields.io/github/issues/chrisns/cosign-keyless-github-admission-webhook.svg)](https://github.com/chrisns/cosign-keyless-github-admission-webhook/issues)
[![GitHub forks](https://img.shields.io/github/forks/chrisns/cosign-keyless-github-admission-webhook.svg)](https://github.com/chrisns/cosign-keyless-github-admission-webhook/network)
[![GitHub stars](https://img.shields.io/github/stars/chrisns/cosign-keyless-github-admission-webhook.svg)](https://github.com/chrisns/cosign-keyless-github-admission-webhook/stargazers)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/chrisns/cosign-keyless-github-admission-webhook/main/LICENSE)

> Proof of concept kubernetes admission webhook that uses `cosign verify` to check the subject of the image matches what you expect

## Installation

```bash
# if you don't already have cert-manager
kubectl apply -f https://github.com/jetstack/cert-manager/releases/latest/download/cert-manager.yaml

kubectl apply -k https://github.com/chrisns/cosign-keyless-github-admission-webhook
```

## Usage

In the pod spec you set an annotation(s) of `subject.cosign.sigstore.dev/CONTAINER_NAME`<sup>\*</sup> to the subject

> \*`CONTAINER_NAME` is the name of the container from your pod specification.

### Full example

```yaml
apiVersion: v1
kind: Pod
metadata:
  annotations:
    subject.cosign.sigstore.dev/demo: https://github.com/chrisns/cosign-keyless-demo/.github/workflows/ci.yml@refs/heads/main
    subject.cosign.sigstore.dev/demoagain: https://github.com/chrisns/cosign-keyless-demo/.github/workflows/ci.yml@refs/heads/main
  name: cosign-keyless-demo
spec:
  containers:
    - image: ghcr.io/chrisns/cosign-keyless-demo:latest
      name: demo
    - image: ghcr.io/chrisns/cosign-keyless-demo:latest
      name: demoagain
```

## 🚨🚨🚨 WHY YOU SHOULDN'T USE THIS 🚨🚨🚨

- It is only checking the `Subject` that is easily faked, I'm not yet sure what proves the origin of key material to tie it back to the OIDC.

- Won't work, at least out the box with private registries or ones that just require authentication, you'll have to wire the credentials up to deployment's secrets