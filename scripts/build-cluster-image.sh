#!/bin/bash

# $1: template file name
# $2: image registry and repo
# $3: image tag

echo "Building cluster image for $1"

template_file=$1
template_name=$(basename "$template_file" .yaml)
image_name="$2/$template_name:$3"

if [[ ! -f "$template_file" ]]; then
  echo "Template file $template_file not found"
  exit 1
fi

# prepare for build cluster image
rm -rf build
mkdir -p build && mkdir -p build/manifests

cp "$template_file" build/manifests/template.yaml

echo "
FROM scratch

USER 65532:65532

COPY registry registry

CMD ["echo "uploaded images for template $template_name""]
" > build/Kubefile

sealos build -f build/Kubefile -t "$image_name"