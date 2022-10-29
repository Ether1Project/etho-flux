image: build

env:
	$(eval GIT_REF=$(shell git rev-parse --short HEAD))

build: env
	@echo building etho_ipfs_node:latest
	@docker build -f Dockerfile -t etho_ipfs_node:latest .

