#!/usr/bin/env bash
# Kustomize golf - make `build puzzle-N` produce exactly puzzle-N/expected.yaml
# Usage: ./check.sh 1|2|3       (run from 07-kustomize-golf/)
set -uo pipefail
cd "$(dirname "$0")"
p="${1:?usage: ./check.sh <puzzle-number>}"
dir="puzzle-$p"
[ -f "$dir/kustomization.yaml" ] || { echo "Create $dir/kustomization.yaml first"; exit 1; }
if command -v kustomize >/dev/null; then out=$(kustomize build "$dir") ; else out=$(kubectl kustomize "$dir"); fi || exit 1
if diff -u "$dir/expected.yaml" <(echo "$out") > /tmp/golf-diff-$p.txt; then
  strokes=$(grep -cvE '^\s*(#|$)' "$dir/kustomization.yaml")
  case $p in 1) par=8;; 2) par=37;; 3) par=42;; esac
  echo "HOLE $p SOLVED in $strokes strokes (par $par)"
  if [ "$strokes" -lt "$par" ]; then echo "Under par! Show it to the instructor."; fi
else
  echo "Not yet. Diff (expected vs yours):"; cat /tmp/golf-diff-$p.txt
fi
