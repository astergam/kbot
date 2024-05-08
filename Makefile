APP_NAME=$(shell basename $(shell git remote get-url origin))
#APP_NAME=$(basename $(git remote get-url origin | sed 's/\.git$//'))
REGISTRY=astergam
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux
TARGETARCH=amd64

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
	docker build -t ${REGISTRY}/${APP_NAME}:${VERSION}-${TARGETOS}-${TARGETARCH} --build-arg TARGETOS=${TARGETOS} .

push:
	docker push ${REGISTRY}/${APP_NAME}:${VERSION}-${TARGETOS}-${TARGETARCH}

clean:
	rm -rf kbot
	docker rmi ${REGISTRY}/${APP_NAME}:${VERSION}-${TARGETOS}-${TARGETARCH}

show:
	echo ${VERSION}