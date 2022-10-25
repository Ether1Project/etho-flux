image: build

env:
	$(eval GIT_REF=$(shell git rev-parse --short HEAD))

build: env
	@echo building etho:${GIT_REF}
	@docker build -f Dockerfile -t etho:${GIT_REF} .

daemon: build
	@docker run -p 8545:8545 -p 300305:300305 -p 30305:30305/udp --mount source=eth0,target=/root eth0:${GIT_REF} --maxpendpeers 50 --maxpeers 1000 --rpc --rpcport 8545 --port 30305 --rpcapi "eth,net,web3" --rpcaddr "0.0.0.0" --rpccorsdomain "*"

node: daemon

interactive: build
	@docker run -i --mount source=etho,target=/root etho:${GIT_REF} attach

attach: interactive

console: interactive
