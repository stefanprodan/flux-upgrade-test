# Flux testing


```bash
helm upgrade -i flux fluxcd/flux \
--namespace flux \
--set git.url=git@github.com:stefanprodan/gitops-test
```

```bash
fluxctl identity --k8s-fwd-ns flux
```

```bash
helm upgrade -i helm-operator fluxcd/helm-operator \
--namespace flux \
--set git.ssh.secretName=flux-git-deploy
```






