## Usage

This image is the unison-image for [docker-sync](https://github.com/EugenMayer/docker-sync) and published on [eugenmayer/unison](https://hub.docker.com/r/eugenmayer/unison/).

The tags are structured as `eugenmayer/unison:$UNISON_VERSION-$OCAML_VERSION-$ARCH` so for example

```
eugenmayer/unison:2.51.3-4.12.0-AMD64
```

The image is used by docker-sync by default, unless it is overridden using the configuration option _<sync_strategy>\_image_ in [docker-sync.yml](https://docker-sync.readthedocs.io/en/latest/getting-started/configuration.html#references). The image uses the latest OCaml and Unison versions available at the time of release. Incase other versions needs to be used (which matches the versions used with docker-sync on the host), build a new docker-image-unison image as follows:

`docker build --build-arg "OCAML_VERSION=<ocaml-version>" --build-arg "UNISON_VERSION=<unison-version>" -t custom-docker-image-unison .`

where `ocaml-version` is any OCaml version available as source-code [here](http://caml.inria.fr/pub/distrib/) and `unison-version` is any Unison version available as source code [here](https://github.com/bcpierce00/unison/releases/).

Or for arm base builds change the image using BASE_IMAGE

`docker build --build-arg "BASE_IMAGE=amd64/alpine:3.12" --build-arg "OCAML_VERSION=<ocaml-version>" --build-arg "UNISON_VERSION=<unison-version>" -t custom-docker-image-unison .`

### Build Examples

For example,

`docker build --build-arg "OCAML_VERSION=4.12.0" --build-arg "UNISON_VERSION=2.51.3" -t custom-docker-image-unison .`

The configuration in the docker-sync.yml would then be:

_unison_image_: 'custom-docker-image-unison'

A lot of credits go to [mickaelperrin](https://github.com/mickaelperrin) - most of the work has been done by him initially.

## What does it do ?

This image simply runs an unison server on the internal port `5000` with the specified user/uid. If the user/uid doesn't
exist, it is created/modified on startup.

You can also combine it with OSXFS as its done in docker-sync native_osx.

## Documentation

You can configure how unison runs by using the following ENV variables:

- `APP_VOLUME` specifies the directory created in the container to store the synced files, `/data` by default
- `OWNER_UID` specifies **the ID of the user** on which the unison process run and the owner of the synced files.
- `MAX_INOTIFY_WATCHES` increases the limit of inotify watches if you need to sync folders with lots of files.

## Credits

- Big thanks at [mickaelperrin](https://github.com/mickaelperrin) for putting hard work into getting this production ready.

## License

What the others did, so:
This docker image is licensed under GPLv3 because Unison is licensed under GPLv3 and is included in the image. See LICENSE.
