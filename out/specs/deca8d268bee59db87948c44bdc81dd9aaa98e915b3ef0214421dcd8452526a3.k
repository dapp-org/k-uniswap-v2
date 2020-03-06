requires "../rules.k"
requires "../bin_runtime.k"

module DECA8D268BEE59DB87948C44BDC81DD9AAA98E915B3EF0214421DCD8452526A3
  imports ETHEREUM-SIMULATION
  imports EVM
  imports RULES
  imports BIN_RUNTIME

// UniswapV2Exchange_swap
rule [UniswapV2Exchange.swap.pass.rough]:
  <k> #execute ~> CONTINUATION => #halt ~> CONTINUATION </k>
  <exit-code> 1 </exit-code>
  <mode> NORMAL </mode>
  <schedule> ISTANBUL </schedule>
  <ethereum>
    <evm>
      <output> .WordStack </output>
      <statusCode> _ => EVMC_SUCCESS </statusCode>
      <callStack> VCallStack </callStack>
      <interimStates> _ </interimStates>
      <touchedAccounts> _ => _ </touchedAccounts>
      <callState>
        <program> UniswapV2Exchange_bin_runtime </program>
        <jumpDests> #computeValidJumpDests(UniswapV2Exchange_bin_runtime) </jumpDests>
        <id> ACCT_ID </id>
        <caller> CALLER_ID </caller>
        <callData> #abiCallData("swap", #uint256(ABI_amount0Out), #uint256(ABI_amount1Out), #address(ABI_to), #bytes(ABI_calldata)) ++ CD => _ </callData>
        <callValue> VCallValue </callValue>
        <wordStack> .WordStack => _ </wordStack>
        <localMem> .Map => _ </localMem>
        <pc> 0 => _ </pc>
        <gas> VGas => _ </gas>
        <memoryUsed> 0 => _ </memoryUsed>
        <callGas> _ => _ </callGas>
        <static> VStatic </static>
        <callDepth> VCallDepth </callDepth>
      </callState>
      <substate>
        <selfDestruct> VSelfDestruct </selfDestruct>
        <log> _ => VLog </log>
        <refund> _ => VRefund </refund>
      </substate>
      <gasPrice> _ </gasPrice>
      <origin> ORIGIN_ID </origin>
      <blockhashes> _ </blockhashes>
      <block>
        <previousHash> _ </previousHash>
        <ommersHash> _ </ommersHash>
        <coinbase> _ </coinbase>
        <stateRoot> _ </stateRoot>
        <transactionsRoot> _ </transactionsRoot>
        <receiptsRoot> _ </receiptsRoot>
        <logsBloom> _ </logsBloom>
        <difficulty> _ </difficulty>
        <number> BLOCK_NUMBER </number>
        <gasLimit> _ </gasLimit>
        <gasUsed> _ </gasUsed>
        <timestamp> TIME </timestamp>
        <extraData> _ </extraData>
        <mixHash> _ </mixHash>
        <blockNonce> _ </blockNonce>
        <ommerBlockHeaders> _ </ommerBlockHeaders>
      </block>
    </evm>
    <network>
      <chainID> VChainId </chainID>
      <activeAccounts> SetItem(ACCT_ID)
      SetItem(Token0)
      SetItem(Token1)
      SetItem(ABI_to)
      SetItem(1)
      SetItem(2)
      SetItem(3)
      SetItem(4)
      SetItem(5)
      SetItem(6)
      SetItem(7)
      SetItem(8) _ </activeAccounts>
      <accounts>
        <account>
          <acctID> ACCT_ID </acctID>
          <balance> ACCT_ID_balance </balance>
          <code> UniswapV2Exchange_bin_runtime </code>
          <storage>
           .Map
          [#UniswapV2Exchange.reserve0_reserve1_blockTimestampLast <- (#WordPackUInt112UInt112UInt32(Reserve0, Reserve1, BlockTimestampLast)) => #WordPackUInt112UInt112UInt32(Reserve0, Reserve1, BlockTimestampLast)]
          [#UniswapV2Exchange.token0 <- (Token0) => Token0]
          [#UniswapV2Exchange.token1 <- (Token1) => Token1]
          [#UniswapV2Exchange.unlocked <- (Unlocked) => Unlocked]
          [#UniswapV2Exchange.price0CumulativeLast <- (Price0) => Price0]
          [#UniswapV2Exchange.price1CumulativeLast <- (Price1) => Price1]
            _:Map
           </storage>
          <origStorage>
           .Map
          [#UniswapV2Exchange.reserve0_reserve1_blockTimestampLast <- (Junk_0)]
          [#UniswapV2Exchange.token0 <- (Junk_1)]
          [#UniswapV2Exchange.token1 <- (Junk_2)]
          [#UniswapV2Exchange.unlocked <- (Junk_3)]
          [#UniswapV2Exchange.price0CumulativeLast <- (Junk_4)]
          [#UniswapV2Exchange.price1CumulativeLast <- (Junk_5)]
            _:Map
           </origStorage>
          <nonce> Nonce_UniswapV2Exchange => _ </nonce>
        </account>
        <account>
          <acctID> Token0 </acctID>
          <balance> Token0_balance </balance>
          <code> UniswapV2Exchange_bin_runtime </code>
          <storage>
           .Map
          [#UniswapV2Exchange.balanceOf[ACCT_ID] <- (Balance0) => Balance0]
          [#UniswapV2Exchange.balanceOf[ABI_to] <- (DstBal0) => DstBal0]
            _:Map
           </storage>
          <origStorage>
           .Map
          [#UniswapV2Exchange.balanceOf[ACCT_ID] <- (Junk_6)]
          [#UniswapV2Exchange.balanceOf[ABI_to] <- (Junk_7)]
            _:Map
           </origStorage>
          <nonce> Nonce_UniswapV2Exchange => _ </nonce>
        </account>
        <account>
          <acctID> Token1 </acctID>
          <balance> Token1_balance </balance>
          <code> UniswapV2Exchange_bin_runtime </code>
          <storage>
           .Map
          [#UniswapV2Exchange.balanceOf[ACCT_ID] <- (Balance1) => Balance1]
          [#UniswapV2Exchange.balanceOf[ABI_to] <- (DstBal1) => DstBal1]
            _:Map
           </storage>
          <origStorage>
           .Map
          [#UniswapV2Exchange.balanceOf[ACCT_ID] <- (Junk_8)]
          [#UniswapV2Exchange.balanceOf[ABI_to] <- (Junk_9)]
            _:Map
           </origStorage>
          <nonce> Nonce_UniswapV2Exchange => _ </nonce>
        </account>
        <account>
          <acctID> ABI_to </acctID>
          <balance> ABI_TO_BAL </balance>
          <code> ABI_TO_CODE </code>
          <storage> _:Map </storage>
          <origStorage> _ </origStorage>
          <nonce> _ </nonce>
        </account>
        <account>
          <acctID> 1 </acctID>
          <balance> ECREC_BAL </balance>
          <code> .WordStack </code>
          <storage> _:Map </storage>
          <origStorage> _ </origStorage>
          <nonce> _ </nonce>
        </account>
        <account>
          <acctID> 2 </acctID>
          <balance> SHA256_BAL </balance>
          <code> .WordStack </code>
          <storage> _:Map </storage>
          <origStorage> _ </origStorage>
          <nonce> _ </nonce>
        </account>
        <account>
          <acctID> 3 </acctID>
          <balance> RIP160_BAL </balance>
          <code> .WordStack </code>
          <storage> _:Map </storage>
          <origStorage> _ </origStorage>
          <nonce> _ </nonce>
        </account>
        <account>
          <acctID> 4 </acctID>
          <balance> ID_BAL </balance>
          <code> .WordStack </code>
          <storage> _:Map </storage>
          <origStorage> _ </origStorage>
          <nonce> _ </nonce>
        </account>
        <account>
          <acctID> 5 </acctID>
          <balance> MODEXP_BAL </balance>
          <code> .WordStack </code>
          <storage> _:Map </storage>
          <origStorage> _ </origStorage>
          <nonce> _ </nonce>
        </account>
        <account>
          <acctID> 6 </acctID>
          <balance> ECADD_BAL </balance>
          <code> .WordStack </code>
          <storage> _:Map </storage>
          <origStorage> _ </origStorage>
          <nonce> _ </nonce>
        </account>
        <account>
          <acctID> 7 </acctID>
          <balance> ECMUL_BAL </balance>
          <code> .WordStack </code>
          <storage> _:Map </storage>
          <origStorage> _ </origStorage>
          <nonce> _ </nonce>
        </account>
        <account>
          <acctID> 8 </acctID>
          <balance> ECPAIRING_BAL </balance>
          <code> .WordStack </code>
          <storage> _:Map </storage>
          <origStorage> _ </origStorage>
          <nonce> _ </nonce>
        </account>
       ...
      </accounts>
      <txOrder> _ </txOrder>
      <txPending> _ </txPending>
      <messages> _ </messages>
    </network>
  </ethereum>
requires #rangeAddress(ACCT_ID)
andBool #notPrecompileAddress(ACCT_ID)
andBool #notPrecompileAddress(ABI_to)
andBool #rangeAddress(CALLER_ID)
andBool #rangeAddress(ORIGIN_ID)
andBool #rangeUInt(256, TIME)
andBool #rangeUInt(256, ACCT_ID_balance)
andBool #rangeUInt(256, ECREC_BAL)
andBool #rangeUInt(256, SHA256_BAL)
andBool #rangeUInt(256, RIP160_BAL)
andBool #rangeUInt(256, ID_BAL)
andBool #rangeUInt(256, MODEXP_BAL)
andBool #rangeUInt(256, ECADD_BAL)
andBool #rangeUInt(256, ECMUL_BAL)
andBool #rangeUInt(256, ECPAIRING_BAL)
andBool VCallDepth <=Int 1024
andBool #rangeUInt(256, VCallValue)
andBool #rangeUInt(256, VChainId)

  andBool (#rangeUInt(256, ABI_amount0Out)
  andBool (#rangeUInt(256, ABI_amount1Out)
  andBool (#rangeAddress(ABI_to)
  andBool (#rangeUInt(112, Reserve0)
  andBool (#rangeUInt(112, Reserve1)
  andBool (#rangeUInt(32, BlockTimestampLast)
  andBool (#rangeUInt(1, Unlocked)
  andBool (#rangeAddress(Token0)
  andBool (#rangeAddress(Token1)
  andBool (#rangeUInt(256, Price0)
  andBool (#rangeUInt(256, Price1)
  andBool (#rangeUInt(256, Balance0)
  andBool (#rangeUInt(256, Balance1)
  andBool (#rangeUInt(256, DstBal0)
  andBool (#rangeUInt(256, DstBal1)
  andBool (#rangeUInt(256, Token0_balance)
  andBool (#rangeUInt(256, Token1_balance)
  andBool ((#sizeByteArray(CD) <=Int 1250000000)
  andBool ((#notPrecompileAddress(Token0))
  andBool ((#notPrecompileAddress(Token1))
  andBool ((ACCT_ID =/=Int Token0)
  andBool ((ACCT_ID =/=Int Token1)
  andBool ((Token0 =/=Int Token1)
  andBool ((ABI_to =/=Int ACCT_ID)
  // TODO - adapt vgas
  andBool (VGas >=Int 3000000
    +Int Cmem(ISTANBUL, ( ( #sizeWordStack(ABI_calldata) +Int 551 ) /Int 32   ))
    +Int (3 *Int ((#sizeWordStack(ABI_calldata) +Int 31) /Int 32))
    +Int (Cmem(ISTANBUL, #memoryUsageUpdate(((#sizeWordStack(ABI_calldata) +Int 583) /Int 32), 356, (((#sizeWordStack(ABI_calldata) +Int 31) &Int not31) +Int 164))) -Int Cmem(ISTANBUL, ((#sizeWordStack(ABI_calldata) +Int 583) /Int 32)))
    +Int (Cmem(ISTANBUL, ((#sizeWordStack(ABI_calldata) +Int 583) /Int 32)) -Int Cmem(ISTANBUL, ((#sizeWordStack(ABI_calldata) +Int 551) /Int 32)))
    +Int (Cmem(ISTANBUL_EVM, maxInt(#memoryUsageUpdate(((#sizeWordStack(ABI_calldata) +Int 583) /Int 32), 356, (((#sizeWordStack(ABI_calldata) +Int 31) &Int not31) +Int 164)), 3)) -Int Cmem(ISTANBUL_EVM, #memoryUsageUpdate(((#sizeWordStack(ABI_calldata) +Int 583) /Int 32), 356, (((#sizeWordStack(ABI_calldata) +Int 31) &Int not31) +Int 164))))
    +Int (Cmem(ISTANBUL_EVM, maxInt(maxInt(#memoryUsageUpdate(((#sizeWordStack(ABI_calldata) +Int 583) /Int 32), 356, (((#sizeWordStack(ABI_calldata) +Int 31) &Int not31) +Int 164)), 3), 13)) -Int Cmem(ISTANBUL_EVM, maxInt(#memoryUsageUpdate(((#sizeWordStack(ABI_calldata) +Int 583) /Int 32), 356, (((#sizeWordStack(ABI_calldata) +Int 31) &Int not31) +Int 164)), 3)))
    +Int (Cmem(ISTANBUL_EVM, maxInt(#memoryUsageUpdate(((#sizeWordStack(ABI_calldata) +Int 583) /Int 32), 356, (((#sizeWordStack(ABI_calldata) +Int 31) &Int not31) +Int 164)), 3)) +Int (14127 -Int Cmem(ISTANBUL_EVM, #memoryUsageUpdate(((#sizeWordStack(ABI_calldata) +Int 583) /Int 32), 356, (((#sizeWordStack(ABI_calldata) +Int 31) &Int not31) +Int 164)))))
    +Int (Cmem(ISTANBUL_EVM, maxInt(maxInt(#memoryUsageUpdate(((#sizeWordStack(ABI_calldata) +Int 583) /Int 32), 356, (((#sizeWordStack(ABI_calldata) +Int 31) &Int not31) +Int 164)), 3), 13)) +Int (14136 -Int Cmem(ISTANBUL_EVM, maxInt(#memoryUsageUpdate(((#sizeWordStack(ABI_calldata) +Int 583) /Int 32), 356, (((#sizeWordStack(ABI_calldata) +Int 31) &Int not31) +Int 164)), 3))))
  andBool (#rangeUInt(256, Junk_0)
  andBool (#rangeUInt(256, Junk_1)
  andBool (#rangeUInt(256, Junk_2)
  andBool (#rangeUInt(256, Junk_3)
  andBool (#rangeUInt(256, Junk_4)
  andBool (#rangeUInt(256, Junk_5)
  andBool (#rangeUInt(256, Junk_6)
  andBool (#rangeUInt(256, Junk_7)
  andBool (#rangeUInt(256, Junk_8)
  andBool (#rangeUInt(256, Junk_9)
  andBool ((Unlocked ==Int 1)
  andBool ((VCallValue ==Int 0)
  // START ADDED RULES
  andBool (#rangeUInt(32, #dyn_size(ABI_calldata, CD))
  andBool (32 <=Int #dyn_size(ABI_calldata, CD)
  andBool (32 +Int #sizeWordStack(ABI_calldata) <=Int #dyn_size(ABI_calldata, CD)
  andBool (Token0 =/=K ABI_to
  andBool (Token1 =/=K ABI_to
  andBool (#unknown_address(ABI_to) ==K true
  andBool (#rangeUInt(256, Balance0 -Int ABI_amount0Out)
  andBool (#rangeUInt(256, DstBal0 +Int ABI_amount0Out)
  andBool (#rangeUInt(256, Balance1 -Int ABI_amount1Out)
  andBool (#rangeUInt(256, DstBal1 +Int ABI_amount1Out)
  // dynamic data is reasonably sized
  andBool (#rangeUInt(32, #sizeWordStack(ABI_calldata))
  // restrict to iterate faster on proofs - remove from final proof
  andBool (ABI_amount0Out =/=Int 0
  andBool (ABI_amount1Out <Int Reserve1
  andBool (ABI_amount0Out <Int Reserve0
  andBool (ABI_amount1Out ==K 0
  andBool (#sizeWordStack(ABI_calldata) =/=K 0
  // TODO - static must be false
  andBool (VStatic ==K false
  // STOP ADDED RULES
  andBool ((VCallDepth <Int 1024))))))))))))))))))))))))))))))))))))))))))))))))))))))))
  andBool #rangeUInt(32, Cmem(ISTANBUL, ( ( #sizeWordStack(ABI_calldata) +Int 551 ) /Int 32   )))
  // TODO - simplify MemGasVal
  andBool Cmem(ISTANBUL, #memoryUsageUpdate(((#sizeWordStack(ABI_calldata) +Int 583) /Int 32), 356, (((#sizeWordStack(ABI_calldata) +Int 31) &Int not31) +Int 164))) -Int Cmem(ISTANBUL, ((#sizeWordStack(ABI_calldata) +Int 583) /Int 32)) >=Int 0
  andBool (Cmem(ISTANBUL, ((#sizeWordStack(ABI_calldata) +Int 583) /Int 32)) -Int Cmem(ISTANBUL, ((#sizeWordStack(ABI_calldata) +Int 551) /Int 32))) >=Int 0
  andBool (Cmem(ISTANBUL_EVM, maxInt(#memoryUsageUpdate(((#sizeWordStack(ABI_calldata) +Int 583) /Int 32), 356, (((#sizeWordStack(ABI_calldata) +Int 31) &Int not31) +Int 164)), 3)) -Int Cmem(ISTANBUL_EVM, #memoryUsageUpdate(((#sizeWordStack(ABI_calldata) +Int 583) /Int 32), 356, (((#sizeWordStack(ABI_calldata) +Int 31) &Int not31) +Int 164)))) >=Int 0
  andBool (Cmem(ISTANBUL_EVM, maxInt(maxInt(#memoryUsageUpdate(((#sizeWordStack(ABI_calldata) +Int 583) /Int 32), 356, (((#sizeWordStack(ABI_calldata) +Int 31) &Int not31) +Int 164)), 3), 13)) -Int Cmem(ISTANBUL_EVM, maxInt(#memoryUsageUpdate(((#sizeWordStack(ABI_calldata) +Int 583) /Int 32), 356, (((#sizeWordStack(ABI_calldata) +Int 31) &Int not31) +Int 164)), 3))) >=Int 0
	andBool (Cmem(ISTANBUL_EVM, maxInt(#memoryUsageUpdate(((#sizeWordStack(ABI_calldata) +Int 583) /Int 32), 356, (((#sizeWordStack(ABI_calldata) +Int 31) &Int not31) +Int 164)), 3)) +Int (14127 -Int Cmem(ISTANBUL_EVM, #memoryUsageUpdate(((#sizeWordStack(ABI_calldata) +Int 583) /Int 32), 356, (((#sizeWordStack(ABI_calldata) +Int 31) &Int not31) +Int 164))))) >=Int 0
  andBool (Cmem(ISTANBUL_EVM, maxInt(maxInt(#memoryUsageUpdate(((#sizeWordStack(ABI_calldata) +Int 583) /Int 32), 356, (((#sizeWordStack(ABI_calldata) +Int 31) &Int not31) +Int 164)), 3), 13)) +Int (14136 -Int Cmem(ISTANBUL_EVM, maxInt(#memoryUsageUpdate(((#sizeWordStack(ABI_calldata) +Int 583) /Int 32), 356, (((#sizeWordStack(ABI_calldata) +Int 31) &Int not31) +Int 164)), 3)))) >=Int 0
  andBool (#sizeByteArray(ABI_TO_CODE) <=Int 1250000000)
  // unknown contract has some code
  andBool #sizeWordStack(ABI_TO_CODE) =/=K 0
  andBool #usedGas(ABI_to) >=Int 0


rule
  <k> #execute ~> CONTINUATION => #halt ~> CONTINUATION </k>
  <exit-code> 1 </exit-code>
  <mode> NORMAL </mode>
  <schedule> ISTANBUL </schedule>
  <ethereum>
    <evm>
      <output> ABI_to_OUTPUT </output>
      <statusCode> _ => EVMC_SUCCESS </statusCode>
      <callStack> VCallStack </callStack>
      <interimStates> _ </interimStates>
      <touchedAccounts> _ => _ </touchedAccounts>
      <callState>
        <program> ABI_to_bin_runtime </program>
        <jumpDests> _ </jumpDests>
        <id> ABI_to </id>
        <caller> _ </caller>
        <callData> _ => _ </callData>
        <callValue> VCallValue </callValue>
        <wordStack> .WordStack => _ </wordStack>
        <localMem> .Map => _ </localMem>
        <pc> 0 => _ </pc>
        <gas> VGas => VGas +Int #usedGas(ABI_to) </gas>
        <memoryUsed> 0 => _ </memoryUsed>
        <callGas> _ => _ </callGas>
        <static> _ </static>
        <callDepth> VCallDepth </callDepth>
      </callState>
      <substate>
        <selfDestruct> VSelfDestruct </selfDestruct>
        <log> _ => VLog </log>
        <refund> _ => VRefund </refund>
      </substate>
      <gasPrice> _ </gasPrice>
      <origin> _ </origin>
      <blockhashes> _ </blockhashes>
      <block>
        <previousHash> _ </previousHash>
        <ommersHash> _ </ommersHash>
        <coinbase> _ </coinbase>
        <stateRoot> _ </stateRoot>
        <transactionsRoot> _ </transactionsRoot>
        <receiptsRoot> _ </receiptsRoot>
        <logsBloom> _ </logsBloom>
        <difficulty> _ </difficulty>
        <number> BLOCK_NUMBER </number>
        <gasLimit> _ </gasLimit>
        <gasUsed> _ </gasUsed>
        <timestamp> TIME </timestamp>
        <extraData> _ </extraData>
        <mixHash> _ </mixHash>
        <blockNonce> _ </blockNonce>
        <ommerBlockHeaders> _ </ommerBlockHeaders>
      </block>
    </evm>
    <network>
      _
    </network>
  </ethereum>
requires #unknown_address(ABI_to) ==K true
[trusted]


endmodule



