format:
	gofmt -s -w ./

build:
	go build -v -o kbot -ldflags "-X="github.com/astergam/kbot/cmd.appVersion=v1.0.5