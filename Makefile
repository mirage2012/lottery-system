NAME="lottery-system"
VERSION="1.0.1"
NAMESPACE="mirage2012"
MAINTAINER="Puri, Mohit <leo.mohit@gmail.com>"
ORGANIZATION="acloudyaffair"
BUILD_DATE=$(shell date -u +"%y-%m-%dt%H:%M:%S%z")
VCS_REF=$(shell git rev-parse HEAD)

REPOSITORY="index.docker.io"
REPOSITORY_DEV="index.docker.io"
FULL_PATH=$(REPOSITORY)/$(NAMESPACE)/$(NAME)
FULL_PATH_DEV=$(REPOSITORY_DEV)/$(NAMESPACE)/$(NAME)


.PHONY: build
build:
	mkdir -p build/linux
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o build/linux/lottery-system -a github.com/mirage2012/${NAME}/src

.PHONY: image
image:
	docker build \
	--build-arg BUILD_DATE=$(BUILD_DATE) \
	--build-arg NAME=$(NAME) \
	--build-arg VERSION=$(VERSION) \
	--build-arg ORGANIZATION=$(ORGANIZATION) \
	--build-arg VCS_REF=$(VCS_REF) \
	--build-arg MAINTAINER=$(MAINTAINER) \
	-t  $(FULL_PATH_DEV):$(VERSION) \
	.
.PHONY: scan
scan:
	trivy  ${FULL_PATH_DEV}:$(VERSION)

.PHONY: push
push:
	docker push ${FULL_PATH_DEV}:$(VERSION)

.PHONY: pull
pull:
	docker pull $(FULL_PATH):$(VERSION)

.PHONY: release
release:
	docker tag $(FULL_PATH_DEV):$(VERSION) $(FULL_PATH):$(VERSION)
	docker push $(FULL_PATH):$(VERSION)

.PHONY: run_local
run_local:
	docker run \
		--rm \
		-p 8090:8090 \
		${FULL_PATH_DEV}:$(VERSION) 

