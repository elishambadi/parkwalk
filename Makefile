# Variables
APP_NAME := elimbadi.io
CMD_DIR := cmd/server
PKG := github.com/elishambadi/elimbadi.io

# Commands
.PHONY: all build run test clean tidy lint help

all: build

## Build the application
build:
	@echo "==> Building the application..."
	go build -o bin/$(APP_NAME) $(CMD_DIR)/main.go

run:
	@echo "==> Running $(APP_NAME) application"
	go run $(CMD_DIR)/main.go

tidy:
	@echo "==>Fetching dependencies..."
	go mod tidy

fmt:
	@echo "==>Formatting code..."
	go fmt ./...

test:
	@echo "==>Running tests..."
	go test ./...