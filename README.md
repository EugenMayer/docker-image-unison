## Usage

This image is the unison-image for [docker-sync](https://github.com/EugenMayer/docker-sync) and published on [eugenmayer/unison](https://hub.docker.com/r/eugenmayer/unison/)
A lot of credits go to [mickaelperrin](https://github.com/mickaelperrin) - most of the work has been done by him initially.

## What does it do ?

This image simply runs an unison server on the internal port `5000` with the specified user/uid. If the user/uid doesn't
exist, it is created/modified on startup.

You can also combine it with OSXFS as its done in docker-sync native_osx.

## Documetation

You can configure how unison runs by using the following ENV variables:
 
 - `APP_VOLUME` specifies the directory created in the container to store the synced files, `/data` by default
 - `OWNER_UID` specifies **the ID of the user** on which the unison process run and the owner of the synced files.
 - `MAX_INOTIFY_WATCHES` increases the limit of inotify watches if you need to sync folders with lots of files (container need to be run on privileged mode to adjust this setting)

## Credits
- Big thanks at [mickaelperrin](https://github.com/mickaelperrin) for putting hard work into getting this production ready

## License
What the others did, so:
This docker image is licensed under GPLv3 because Unison is licensed under GPLv3 and is included in the image. See LICENSE.
