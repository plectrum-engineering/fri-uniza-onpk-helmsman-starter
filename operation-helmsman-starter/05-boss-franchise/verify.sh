#!/usr/bin/env bash
# Usage: ./verify.sh [bistro-byte|rocket-rentals]   (run from 05-boss-franchise/)
set -uo pipefail
cd "$(dirname "$0")"
build() {
  if command -v kustomize >/dev/null; then kustomize build --enable-helm "clients/$1"
  else kubectl kustomize --enable-helm "clients/$1"; fi
}
pass=0; fail=0
check() { # client, description, grep pattern
  if build "$1" 2>/dev/null | grep -Eq -- "$3"; then echo "  [PASS] $2"; pass=$((pass+1));
  else echo "  [FAIL] $2"; fail=$((fail+1)); fi
}
run_bistro() {
  echo "== bistro-byte"
  check bistro-byte "namespace bistro-byte"          '^  namespace: bistro-byte'
  check bistro-byte "Namespace object exists"        '^kind: Namespace'
  check bistro-byte "label client=bistro-byte"       'client: bistro-byte'
  check bistro-byte "brand color #6d4c41"            "#6d4c41"
  check bistro-byte "brand message"                  'Bistro Byte - fresh bytes daily'
  check bistro-byte "2 replicas"                     '^  replicas: 2'
  if build bistro-byte 2>/dev/null | grep -q "^kind: Pod"; then echo "  [FAIL] no helm test Pods in the output"; fail=$((fail+1)); else echo "  [PASS] no helm test Pods in the output"; pass=$((pass+1)); fi
}
run_rocket() {
  echo "== rocket-rentals"
  check rocket-rentals "namespace rocket-rentals"    '^  namespace: rocket-rentals'
  check rocket-rentals "Namespace object exists"     '^kind: Namespace'
  check rocket-rentals "label client=rocket-rentals" 'client: rocket-rentals'
  check rocket-rentals "brand color #1565c0"         "#1565c0"
  check rocket-rentals "brand message"               'Rocket Rentals - to the moon and back'
  check rocket-rentals "3 replicas"                  '^  replicas: 3'
  check rocket-rentals "image pinned to 6.14.0"      'podinfo:6\.14\.0'
  if build rocket-rentals 2>/dev/null | grep -q "^kind: Pod"; then echo "  [FAIL] no helm test Pods in the output"; fail=$((fail+1)); else echo "  [PASS] no helm test Pods in the output"; pass=$((pass+1)); fi
}
case "${1:-all}" in
  bistro-byte) run_bistro ;;
  rocket-rentals) run_rocket ;;
  *) run_bistro; run_rocket ;;
esac
echo; echo "Score: $pass passed, $fail failed"
[ "$fail" -eq 0 ] && echo "Mission complete. Tell your instructor the code word: SEXTANT"
