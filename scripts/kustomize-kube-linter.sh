#!/usr/bin/sh

echo $@

if ! command -v kustomize &> /dev/null
then
    echo "kustomize not found on PATH. Skipping validation"
    exit
fi


if ! command -v kube-linter &> /dev/null
then
    echo "kube-linter not found on PATH. Skipping validation"
    exit
fi

for kustomization in "$@"
do
    kustomize build $kustomization | kube-linter lint -
done
