APP=$(basename $(git remote get-url origin | sed 's/\.git$//'))
REGISTRY=astergam
VERSION=$(git describe --tags --abbrev=0)-$(git rev-parse --short HEAD)
#VERSION=v1.0.6-$(shell git rev-parse --short HEAD)
TARGETOS=linux
TARGETARCH=amd64
#IMAGENAME := ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}

get:
	go get

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

build: format
	go get gopkg.in/telebot.v3
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="https://github.com/astergam/kbot/cmd.appVersion=${VERSION}

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}  --build-arg TARGETARCH=${TARGETARCH}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

clean:
	rm -rf kbot
	docker rmi ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

show:
	echo ${VERSION}
