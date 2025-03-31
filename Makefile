# Analyze Dockerfile with checkov (pre-build)
checkov:
	checkov --config-file checkov.yaml -d alpine --framework dockerfile

# Analyze Dockerfile with grype (post-build)
# Usage:
# make grype-v1x
# make grype-v2x
grype-%:
	grype trickstercache/trickster:$$(yq '.$*' versions.yaml -r)

install-tools:
	brew install checkov
	brew tap anchore/grype
	brew install grype

build:
	docker build -t trickster:v1x -f alpine/Dockerfile.v1x alpine
	docker build -t trickster:v2x -f alpine/Dockerfile.v2x alpine
	docker build -t trickster:v2x-distroless -f distroless/Dockerfile.v2x distroless
