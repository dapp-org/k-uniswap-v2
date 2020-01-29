DAPP_DIR=$(CURDIR)/uniswap-v2-core
DAPP_SRC=contracts

SOLC_VERSION=0.5.16
SOLC_FLAGS="--optimize --optimize-runs 999999"

.PHONY: all klab dapp waffle prove

all: klab waffle

klab:
	cd deps/klab && make deps && cd -

dapp:
	dapp --version
	cd $(DAPP_DIR) && DAPP_SRC=$(DAPP_SRC) DAPP_SOLC_VERSION=$(SOLC_VERSION) SOLC_FLAGS=$(SOLC_FLAGS) dapp build && cd -

waffle:
	cd $(DAPP_DIR) && yarn install && yarn compile && cd -

prove: klab waffle
	klab build
	klab prove-all
