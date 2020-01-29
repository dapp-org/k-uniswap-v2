DAPP_DIR=$(CURDIR)/uniswap-v2-core

.PHONY: all klab dapp waffle prove

all: klab waffle

klab:
	cd deps/klab && make deps && cd -

dapp: export DAPP_SRC=contracts
dapp: export DAPP_SOLC_VERSION=0.5.16
dapp: export SOLC_FLAGS=--optimize --optimize-runs 999999
dapp:
	dapp --version
	cd ${DAPP_DIR} && dapp build && cd -

waffle:
	cd $(DAPP_DIR) && yarn install && yarn compile && cd -

prove: klab waffle
	klab build
	klab prove-all
