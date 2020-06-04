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

FROM alpine:3.12
RUN apk --no-cache add ca-certificates tzdata
RUN set -ex; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		aarch64) arch='arm64' ;; \
		x86_64) arch='amd64' ;; \
		*) echo >&2 "error: unsupported architecture: $apkArch"; exit 1 ;; \
	esac; \
   	cd /tmp && \
	wget --quiet -O ./trickster.tar.gz "https://github.com/tricksterproxy/trickster/releases/download/v1.1.1/trickster-1.1.1.tar.gz" && \
    tar zvxf ./trickster.tar.gz && \
    mkdir -p /etc/trickster && \
    mv ./trickster-1.1.1/bin/trickster-1.1.1.linux-${arch} /usr/local/bin/trickster && \
    mv ./trickster-1.1.1/conf/example.conf /etc/trickster/trickster.conf && \
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
    org.opencontainers.image.vendor="Comcast Corporation" \
	org.opencontainers.image.url="https://tricksterproxy.io" \
	org.opencontainers.image.title="Trickster" \
	org.opencontainers.image.description="an HTTP Reverse Proxy Cache and time series dashboard accelerator" \
	org.opencontainers.image.version="1.1.1" \
	org.opencontainers.image.documentation="https://github.com/tricksterproxy/trickster/tree/master/docs"
