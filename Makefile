NAME=echo-server

GOVERSION ?= 1.12.7
GOOS?=linux
GOARCH?=amd64
GO111MODULE=on

OUTPUT_DIR=bin
PKG ?= github.com/bells17/echo-server

all: init test build

.PHONY: build
build:
	@echo "==> Building the cmd"
	@docker run -v $(PWD):/go/src/$(PKG) \
	  -w /go/src/$(PKG) \
	  -e GOOS=$(GOOS) -e GOARCH=$(GOARCH) -e CGO_ENABLED=0 -e GOFLAGS=-mod=vendor golang:$(GOVERSION)-alpine3.10 \
		go build -o $(OUTPUT_DIR)/$(NAME)-$(GOOS)-$(GOARCH) cmd/$(NAME)/main.go

.PHONY: test
test:
	@echo "==> Testing all packages"
	@go test -v ./...

.PHONY: clean
clean:
	@echo "==> Cleaning releases"
	go clean -i -x ./...
	rm -fr $(PWD)/$(OUTPUT_DIR)/*

.PHONY: init
init: vendor
	@echo "==> Initializing..."
	@mkdir -p $(OUTPUT_DIR)

.PHONY: vendor
vendor:
	@echo "==> Install modules"
	@GO111MODULE=on go mod tidy
	@GO111MODULE=on go mod vendor
