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

cache: .make.add .make.sub .make.mul .make.balanceOf .make.feeTo .make.getReserves

# --- safemath ---

.make.add:
	klab build
	klab prove --dump --log UniswapV2Pair_add_pass_rough
	klab get-gas UniswapV2Pair_add_pass_rough
	klab build
	klab prove --log UniswapV2Pair_add_pass
	touch $@

.make.sub:
	klab build
	klab prove --dump --log UniswapV2Pair_sub_pass_rough
	klab get-gas UniswapV2Pair_sub_pass_rough
	klab build
	klab prove --log UniswapV2Pair_sub_pass
	touch $@

.make.mul:
	klab build
	klab prove --dump --log UniswapV2Pair_mul_pass_rough
	klab get-gas UniswapV2Pair_mul_pass_rough
	klab build
	klab prove --log UniswapV2Pair_mul_pass
	touch $@

# --- ERC20 ---

.make.balanceOf:
	klab build
	klab prove --dump --log UniswapV2Pair_balanceOf_pass_rough
	klab get-gas UniswapV2Pair_balanceOf_pass_rough
	klab build
	klab prove --log UniswapV2Pair_balanceOf_pass
	touch $@

# --- Factory ---

.make.feeTo:
	klab build
	klab prove --dump --log UniswapV2Pair_feeTo_pass_rough
	klab get-gas UniswapV2Pair_feeTo_pass_rough
	klab build
	klab prove --log UniswapV2Pair_feeTo_pass
	touch $@

# --- Pair ---

.make.getReserves:
	klab build
	klab prove --dump --log UniswapV2Pair_getReserves_pass_rough
	klab get-gas UniswapV2Pair_getReserves_pass_rough
	klab build
	klab prove --log UniswapV2Pair_getReserves_pass
	touch $@
