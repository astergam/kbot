APP=$(shell basename $(shell git remote get-url origin | sed 's/\.git$//'))
REGISTRY="ghcr.io$/astergam"
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux
TARGETARCH="amd64"

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
	echo "see that:"
	echo "${REGISTRY}"
	echo "${APP}"
	echo "${VERSION}"
	echo "${TARGETOS}"
	echo "${TARGETARCH}"
	echo "${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH} --build-arg TARGETOS=${TARGETOS} ."
	docker build -t ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH} --build-arg TARGETOS=${TARGETOS} .

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}

clean:
	rm -rf kbot
	docker rmi ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}

show:
	echo ${VERSION}