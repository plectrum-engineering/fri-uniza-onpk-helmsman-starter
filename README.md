# Operation Helmsman - lab pack (ONPK 2026)

Helm & Kustomize hands-on. Work in pairs, one folder per mission.

## Before you start

```bash
minikube start
./00-setup/check-tools.sh
```

You need `kubectl` (Kustomize is built in) and **Helm 4** (`brew install helm` / `winget install Helm.Helm`).
The standalone `kustomize` binary is optional.

## Missions

| # | Folder | Mission | Check |
|---|--------|---------|-------|
| 1 | `01-helm-consumer` | Paint the pod - install, upgrade and roll back podinfo | browser + `helm history` |
| 2 | `02-guestbook-chart` | Chart the guestbook - finish the starter chart | `helm lint`, `helm test` |
| 3 | `03-release-day` | Two environments, a failed release, packaging | `helm history` |
| 4 | `04-kustomize` | Three environments with overlays and components | `kubectl kustomize overlays/<env>` |
| 5 | `05-boss-franchise` | White-label podinfo for two clients (Helm inside Kustomize) | `./verify.sh` |
| 6 | `06-escape-room` | Fix the broken `lighthouse` chart (8 locks) | `helm test` + code word |
| 7 | `07-kustomize-golf` | Match `expected.yaml` in as few lines as possible | `./check.sh <hole>` |

The full task list for each mission is on the challenge slides. Every starter file marks the work with `TODO`.

## Useful commands

```bash
helm template <release> <chart> -f <values>     # render locally
helm lint <chart>                               # static checks
helm upgrade --install <release> <chart> -n <ns> --create-namespace -f <values>
helm history <release> -n <ns>; helm rollback <release> <rev> -n <ns>

kubectl kustomize <dir>                         # render
kubectl diff -k <dir>                           # preview
kubectl apply -k <dir>                          # deploy
kubectl kustomize --enable-helm <dir>           # Kustomize + helmCharts (needs helm on PATH)
```

## Clean up

```bash
helm uninstall --namespace mission1 paint paint2
helm uninstall gb -n guestbook-dev; helm uninstall gb -n guestbook-prod
kubectl delete -k 04-kustomize/overlays/dev     # repeat for staging, prod
kubectl delete ns bistro-byte rocket-rentals lighthouse --ignore-not-found
```
