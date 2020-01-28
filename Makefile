DAPP_DIR=$(CURDIR)/uniswap-v2-core
DAPP_SRC=contracts

SOLC_VERSION=0.5.16
SOLC_FLAGS="--optimize --optimize-runs 999999"

all: dapp waffle

dapp:
	dapp --version
	git submodule update --init --recursive
	cd $(DAPP_DIR) && DAPP_SRC=$(DAPP_SRC) DAPP_SOLC_VERSION=$(SOLC_VERSION) SOLC_FLAGS=$(SOLC_FLAGS) dapp build && cd -

waffle:
	git submodule update --init --recursive
	cd $(DAPP_DIR) && yarn install && yarn compile && cd -
