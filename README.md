
## arc controller install

```
helm install arc \
  --namespace arc-systems \
  --create-namespace \
  oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set-controller
```

## pat 発行

```
GITHUB_CONFIG_URL="https://github.com/<username>/<repo_name>"
GITHUB_PAT="<PAT>"
```

## arc runner install

```
helm install arc-runner-set \
    --namespace arc-runners \
    --create-namespace \
    --set githubConfigUrl="${GITHUB_CONFIG_URL}" \
    --set githubConfigSecret.github_token="${GITHUB_PAT}" \
    --set containerMode.type="dind"
    oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set
```

## login with pat

```
echo $github_pat | docker login ghcr.io -u slidict --password-stdin
```

## build

```
docker build -t ghcr.io/slidict/action-runner-systems:latest .
docker push ghcr.io/slidict/action-runner-systems:latest
```

## values.yml

https://github.com/actions/actions-runner-controller/blob/master/charts/gha-runner-scale-set/values.yaml

```
helm upgrade arc-runner-set \
  oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set \
  -n arc-runners \
  -f values.yaml
```

### How to update the GitHub PAT used by the ARC runners

1. Create a new Personal Access Token (PAT) with `repo` and `workflow` scopes on GitHub.
2. Update the Kubernetes Secret:

```bash
kubectl create secret generic arc-runner-set-<LISTENER_SUFFIX>-listener \
  --namespace arc-systems \
  --from-literal=github_token=<NEW_PAT> \
  --dry-run=client -o yaml | kubectl apply -f -
