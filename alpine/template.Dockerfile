# Copyright 2025 The Trickster Authors
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

FROM alpine:3.13
ARG TRICKSTER_VERSION=4.5.6
RUN apk --no-cache add ca-certificates tzdata
RUN set -ex; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		aarch64) arch='arm64' ;; \
		x86_64) arch='amd64' ;; \
		*) echo >&2 "error: unsupported architecture: $apkArch"; exit 1 ;; \
	esac; \
   	cd /tmp && \
	wget --quiet -O ./trickster.tar.gz "https://github.com/tricksterproxy/trickster/releases/download/v${TRICKSTER_VERSION}/trickster-${TRICKSTER_VERSION}.tar.gz" && \
    tar zvxf ./trickster.tar.gz && \
    mkdir -p /etc/trickster && \
    mv ./trickster-${TRICKSTER_VERSION}/bin/trickster-${TRICKSTER_VERSION}.linux-${arch} /usr/local/bin/trickster && \
    mv ./trickster-${TRICKSTER_VERSION}/conf/example.full.yaml /etc/trickster/trickster.yaml && \
	rm -rf ./trickster* && \
    chown nobody /usr/local/bin/trickster && \
	chmod +x /usr/local/bin/trickster

EXPOSE 8480
EXPOSE 8481
EXPOSE 8483
EXPOSE 8484

USER nobody
ENTRYPOINT ["trickster"]

# Metadata
LABEL maintainer "The Trickster Authors <trickster-developers@googlegroups.com>" \
    org.opencontainers.image.vendor="Trickster Authors" \
	org.opencontainers.image.url="https://tricksterproxy.io" \
	org.opencontainers.image.title="Trickster" \
	org.opencontainers.image.description="an HTTP Reverse Proxy Cache and time series dashboard accelerator" \
	org.opencontainers.image.version="${TRICKSTER_VERSION}" \
	org.opencontainers.image.documentation="https://github.com/tricksterproxy/trickster/tree/main/docs"
