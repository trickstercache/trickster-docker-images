# NOTE

We have relocated the Trickster Dockerfile and Docker image publishing pipeline into the the [main Trickster project](https://github.com/trickstercache/trickster). This project is archived, unsupported and may not work anymore.

# Trickster Docker Images

This project maintains and publishes the Dockerfile for Trickster. The GitHub actions in this project build and publish images to Docker Hub via GitHub Actions.

You can access the images pushed by this repo on Docker Hub at <https://hub.docker.com/r/tricksterproxy/trickster>.

This repository maintains a docker image for the major supported trickster versions -- v1 and v2.

## Building an image

1. First, identify the corresponding Dockerfile:

- alpine/Dockerfile.v1x -- installs the last promoted v1 trickster release
- alpine/Dockerfile.v2x -- installs the last promoted v2 trickster release

2. Modify the image. Once the Dockerfile is prepared, you can run `docker build --build-arg TRICKSTER_VERSION=2.3.4 -f ./alpine/Dockerfile.v2x -t your:tag .` to create a Docker image for the prepared version to test locally.

If the provided version does not have released binaries, then you will not be able to successfully build an image.

3. Once the changes are merged to main, the images are pushed to Docker Hub

### Updating the Trickster version

Unless there is a change to the Dockerfile, trickster application version updates are managed by modifying the `versions.yaml` file at the root of the repository.
