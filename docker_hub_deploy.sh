#!/bin/bash
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
echo "Deploying different arches on docker hub"
docker push eugenmayer/unison:$UNISON_VERSION-$OCAML_VERSION-AMD64
docker push eugenmayer/unison:$UNISON_VERSION-$OCAML_VERSION-ARM64

echo "Creating manifests for different arches: AMD64 / ARM64"
docker manifest create eugenmayer/unison:$UNISON_VERSION-$OCAML_VERSION eugenmayer/unison:$UNISON_VERSION-$OCAML_VERSION-AMD64 eugenmayer/unison:$UNISON_VERSION-$OCAML_VERSION-ARM64
echo "Pushing manifest: eugenmayer/unison:$UNISON_VERSION-$OCAML_VERSION"
docker manifest push eugenmayer/unison:$UNISON_VERSION-$OCAML_VERSION
