APP=$(shell basename $(shell git remote get-url origin) | sed 's/\.git$$//')
REGISTRY=ghcr.io/astergam
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
#VERSION=v1.0.6-$(shell git rev-parse --short HEAD) 
TARGETOS=linux
TARGETARCH=amd64
IMAGENAME := ${REGISTRY}/${APP}:${VERSION}-${OS}-${ARCH}

get:
	go get

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/astergam/kbot/cmd.appVersion=${VERSION}

image:
	docker build . -t ${IMAGENAME}

push:
	docker push ${IMAGENAME}

clean:
	rm -rf kbot
	docker rmi ${IMAGENAME}

show:
	echo ${VERSION}
