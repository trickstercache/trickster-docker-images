# Copyright 2018 Comcast Cable Communications Management, LLC
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#!/usr/bin/env bash

set -e
set -u # Exit on error when uninitialized variable

if ! type envsubst >/dev/null 2>&1 ; then
    echo
    echo 'envsubst command is missing from your $PATH. Install gettext.'
    echo 'On MacOS run: brew install gettext'
    echo
    exit 1
fi

if [ $# -eq 0 ] ; then
    echo
    echo "Usage:     ./prepare_versioned_release.sh \$VERSION"
    echo
    echo "Example:   ./prepare_versioned_release.sh 1.1.0"
    echo
    echo "Version Examples:  1.1.0   1.1.0-beta1   1.1.0-rc12   1.1.0-alpha98"
    echo
    exit 1
fi

if ! [[ $1 =~ ^[0-9]+\.[0-9]+\.[0-9]+(\-(alpha|beta|rc)+[0-9]+)?$ ]] ; then
    echo
    echo "Invalid version string: $1"
    echo
    echo 'Must match /^[0-9]+\.[0-9]+\.[0-9]+(\-(alpha|beta|rc)+[0-9]+)?$/'
    echo
    echo "Examples:  1.1.0   1.1.0-beta1   1.1.0-rc12   1.1.0-alpha98"
    echo
    exit 1
fi

export VERSION=$1

BRANCH=$(git branch | grep '*' | awk '{print $2}')
if [ $? -ne 0 ] ; then
    echo
    echo "`git branch` returned an error."
    echo
fi

MAJORVER=$(echo $VERSION | awk -F '.' '{print $1}')
MINORVER=$(echo $VERSION | awk -F '.' '{print $2}')
EXPECTED_BRANCH="v${MAJORVER}.${MINORVER}.x"

if [[ "$BRANCH" != "$EXPECTED_BRANCH" ]] ; then
    echo
    echo "You must be on a branch called ${EXPECTED_BRANCH} to prepare version $VERSION"
    echo
    exit 1
fi

export ALPINE_VERSION=3.13
echo "${VERSION}" > version

WORKING_DIR="$(cd "$(dirname "$0")" && pwd -P)"
pushd "${WORKING_DIR}" >/dev/null

ALPINE_DIR="./alpine"

[ -d "${ALPINE_DIR}" ] || ( echo "= No directory found for ${ALPINE_DIR}" && exit 1)

DOCKERFILE="${ALPINE_DIR}/Dockerfile"
TMPLFILE="${ALPINE_DIR}/template.Dockerfile"

rm -f "${DOCKERFILE}"
envsubst \$ALPINE_VERSION,\$VERSION < "${TMPLFILE}" > "${DOCKERFILE}"

echo 
echo "  Alpine Dockerfile is ready at ./alpine/Dockerfile"
echo


echo "  Now build docker images locally or maintainers can tag/push to trigger a release build."
echo

popd >/dev/null
