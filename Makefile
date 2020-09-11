VERSION ?= $(shell cat VERSION)

.PHONY: help build server_start

.DEFAULT_GOAL := help

build: ## build the app for deployment
	npm run build

server_start: ## run the server and do the listenings
	npm run develop

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'