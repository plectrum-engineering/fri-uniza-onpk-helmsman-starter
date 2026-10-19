#!/usr/bin/env bash
# Operation Helmsman - pre-flight check
ok() { printf "  [ OK ] %s\n" "$1"; }
ko() { printf "  [FAIL] %s\n" "$1"; FAILED=1; }
FAILED=0
echo "Pre-flight check"
command -v kubectl >/dev/null && ok "kubectl $(kubectl version --client -o json 2>/dev/null | grep -m1 gitVersion | cut -d'"' -f4)" || ko "kubectl not found"
command -v helm    >/dev/null && ok "helm $(helm version --short 2>/dev/null)" || ko "helm not found  ->  https://helm.sh/docs/intro/install/"
case "$(helm version --short 2>/dev/null)" in v4*) ok "Helm 4 detected";; v3*) echo "  [WARN] Helm 3 detected - labs work, but flag names differ (--atomic vs --rollback-on-failure)";; esac
kubectl kustomize --help >/dev/null 2>&1 && ok "kubectl kustomize (built-in)" || ko "kubectl kustomize missing"
command -v kustomize >/dev/null && ok "standalone kustomize $(kustomize version 2>/dev/null) (optional)" || echo "  [INFO] standalone kustomize not installed (optional)"
kubectl cluster-info >/dev/null 2>&1 && ok "cluster reachable: $(kubectl config current-context)" || ko "no cluster - run: minikube start"
[ "$FAILED" -eq 0 ] && echo "All systems go. Welcome aboard, helmsman." || echo "Fix the FAILs above before Mission 1."
