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
