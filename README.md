# GitOps multi-tenancy


A multi-tenant cluster is shared by multiple teams.
As a cluster operator, you can isolate tenants using Kubernetes namespaces.

The cluster administrators can provision a namespace per team. Each team is owning a git repository where the
namespace workloads are defined. When a team member wants to change something, he/she will push the change to the team's 
repository and those changes will be applied only to the team's namespace.

Team namespace structure:

| Team      | Namespace   | Git Repository                 | Scope
| --------- | ----------- | --------------------------     | ---------------
| SRE       | flux-system | git@github.com:org/dev-cluster | Cluster wide Flux (syncs namespaces, accounts, CRDs, controllers)
| DEV-TEAM1 | team1       | git@github.com:org/dev-team1   | Namespace scoped Flux (syncs deployments, services, roles)
| DEV-TEAM2 | team2       | git@github.com:org/dev-team2   | Namespace scoped Flux (syncs deployments, services, roles)

Clone this repository into `org/dev-cluster` and change the git repo URL to point to your fork:

```bash
vim ./system/flux-patch.yaml

--git-url=git@github.com:org/dev-cluster
```

Create a repository for team1 and change the git URL in `cluster/team1` dir:

```bash
vim ./cluster/team1/flux-patch.yaml

--git-url=git@github.com:org/dev-team1
```

Install the cluster wide Flux with kubectl kustomize:

```bash
kubectl apply -k ./system/
```

Get the public SSH key with:

```bash
fluxctl --k8s-fwd-ns=flux-system identity
```

Add the public key to the `github.com:org/dev-cluster` repository deploy keys with write access.

The cluster wide Flux will do the following:
* creates the cluster objects from `cluster/common` directory (CRDs, cluster roles, network polices etc)
* creates the `team1` namespace and deploys a Flux instance with restricted access to that namespace

Get the public SSH key for team1 with:

```bash
fluxctl --k8s-fwd-ns=team1 identity
```

Add the public key to the `github.com:org/dev-team1` repository deploy keys with write access. The team1's Flux
will apply the manifests from `org/dev-team1` repository only in the `team1` namespace.

If team1 needs to deploy a controller that depends on a CRD or a cluster role, they'll 
have to open a PR in the `org/dev-cluster`repository and add those cluster wide objects in the `cluster/common` directory.

If you want to add another team to the cluster, first create a git repository as `github.com:org/dev-team2`.

Run the create team script:

```bash
./scripts/create-team.sh team2

team2 created at cluster/team2/
team2 added to cluster/kustomization.yaml
```

Change the git URL in `cluster/team2` dir:

```bash
vim ./cluster/team2/flux-patch.yaml

--git-url=git@github.com:org/dev-team2
```

Push the changes to the master branch of `org/dev-cluster` and sync with the cluster:

```bash
fluxctl --k8s-fwd-ns=flux-system sync
```

Get the team2 public SSH key with:
                                       
```bash
fluxctl --k8s-fwd-ns=team2 identity
```

Add the public key to the `github.com:org/dev-team2` repository deploy keys with write access. The team2's Flux
will apply the manifests from `org/dev-team2` repository only in the `team2` namespace.








