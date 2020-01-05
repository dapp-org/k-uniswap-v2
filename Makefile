DAPP_DIR = $(CURDIR)/uniswap-v2-core

dapp:
	dapp --version
	cd $(DAPP_DIR) && DAPP_SRC=contracts dapp --use solc:0.5.15 build && cd -
