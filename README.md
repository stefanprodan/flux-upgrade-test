# Flux testing


```bash
kubectl create ns flux
```

```bash
helm upgrade -i flux fluxcd/flux \
--namespace flux \
--set syncGarbageCollection.enabled=true \
--set git.url=git@github.com:stefanprodan/gitops-test
```

```bash
fluxctl identity --k8s-fwd-ns flux
```

```bash
helm upgrade -i helm-operator fluxcd/helm-operator \
--namespace flux \
--set helm.versions=v3 \
--set git.ssh.secretName=flux-git-deploy
```

```bash
fluxctl sync --k8s-fwd-ns flux
```





