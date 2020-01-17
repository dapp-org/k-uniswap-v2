DAPP_DIR=$(CURDIR)/uniswap-v2-core
DAPP_SRC=contracts

SOLC_VERSION=0.5.15
SOLC_FLAGS="--optimize --optimize-runs 200"

dapp:
	dapp --version
	git submodule update --init --recursive
	cd $(DAPP_DIR) && DAPP_SRC=$(DAPP_SRC) DAPP_SOLC_VERSION=$(SOLC_VERSION) SOLC_FLAGS=$(SOLC_FLAGS) dapp build && cd -
