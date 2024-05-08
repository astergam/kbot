APP=$(shell basename $(shell git remote get-url origin | sed 's/\.git$//'))
echo "${APP}"
REGISTRY=ghcr.io/astergam
echo "${REGISTRY}"
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
echo "${VERSION}"
TARGETOS=linux
echo "${TARGETOS}"
TARGETARCH=amd64
echo "${TARGETARCH}"

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
	echo "${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH} --build-arg TARGETOS=${TARGETOS} ."
	docker build -t ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH} --build-arg TARGETOS=${TARGETOS} .

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}

clean:
	rm -rf kbot
	docker rmi ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}

show:
	echo ${VERSION}