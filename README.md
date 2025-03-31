# NOTE

We have relocated the Trickster Dockerfile and Docker image publishing pipeline into the the [main Trickster project](https://github.com/trickstercache/trickster). This project is archived, unsupported and may not work anymore.

# Trickster Docker Images

This project maintains and publishes the Dockerfile for Trickster. The GitHub actions in this project build and publish images to Docker Hub via GitHub Actions.

You can access the images pushed by this repo on Docker Hub at <https://hub.docker.com/r/tricksterproxy/trickster>.

To build images, checkout the project locally, switch to a supported version branch (currently `v1.1.x`) and run `./prepare_versioned_release.sh <NEW_VERSION_NUMBER>`. The version number argument must be in the proper semantic versioning format, which is well-defined in the script output, and must correspond to a matching release tag in the [main Trickster project](https://github.com/tricksterproxy/trickster/releases), which houses the built release binaries downloaded by the builder.

Once the Dockerfile is prepared, you can run `docker build -f ./alpine/Dockerfile -t your:tag .` to create a Docker image for the prepared version. If the provided version does not have released binaries, then you will not be able to successfully build an image.

Maintainers, once satisfied with the image quality, can tag the newly prepared Dockerfile with a proper semantic version, and push the tag to trigger an automated build/push to Docker Hub. The automated process will publish `linux/amd64` and `linux/arm64` images into the same tag.

Example usage:

```bash
$ git clone https://github.com/tricksterproxy/trickster-docker-images.git
$ cd trickster-docker-images

$ export VERSION=1.1.0
$ export BRANCH=v1.1.x

$ git checkout $BRANCH

$ ./prepare_versioned_release.sh $VERSION

  Alpine Dockerfile is ready at ./alpine/Dockerfile

  Now build docker images locally or maintainers can tag/push to trigger a release build.

$ docker build -f ./alpine/Dockerfile -t image-name:image-tag .

# Maintainers

$ git commit -m "prepare version $VERSION" ./alpine/Dockerfile
$ git tag "v${VERSION}"
$ git push origin $BRANCH
```
