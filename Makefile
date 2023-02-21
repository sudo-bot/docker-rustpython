IMAGE_TAG ?= docker-rustpython
# All: linux/386,linux/amd64,linux/arm/v5,linux/arm/v7,linux/arm64/v8,linux/mips64le,linux/ppc64le,linux/s390x
# Supported by rust (Debian variant, alpine has 2 less): linux/386,linux/amd64,linux/arm/v7,linux/arm64/v8
# Supported by alpine: linux/386,linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64/v8,linux/ppc64le,linux/s390x
PLATFORM ?= linux/amd64

ACTION ?= load
PROGRESS_MODE ?= plain

.PHONY: docker-build

docker-build:
	# https://github.com/docker/buildx#building
	docker buildx build \
		--tag $(IMAGE_TAG) \
		--progress $(PROGRESS_MODE) \
		--platform $(PLATFORM) \
		--build-arg VCS_REF=`git rev-parse HEAD` \
		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
		--$(ACTION) \
		./docker
