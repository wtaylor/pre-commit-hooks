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

compiled_yaml_doc=$(mktemp)
trap "rm -f $compiled_yaml_doc" 0 2 3 15

for kustomization in "$@"
do
    kustomize build $(dirname $kustomization) >> $compiled_yaml_doc
    echo -e "\n---" >> $compiled_yaml_doc
done

kube-linter lint $compiled_yaml_doc
