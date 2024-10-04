// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {IIdleToken} from "../src/IIdleToken.sol";

contract SimulateAllocations is Script {
  address public constant REBALANCER  = 0xB3C8e5534F0063545CBbb7Ce86854Bf42dB8872B;
  address public constant IDLE_USDC = 0x5274891bEC421B39D23760c04A6755eCB444797C;
  address public constant IDLE_DAI = 0x3fE7940616e5Bc47b0775a0dccf6237893353bB4;
  address public constant IDLE_USDT = 0xF34842d05A1c888Ca02769A633DF37177415C2f8;
  // @notice run with
  // forge script ./script/SimulateAllocations.s.sol:SimulateAllocations -v --sig "testIdleDAI(uint256,uint256[][])" "[[100000,0,0],[0,100000,0]]"
  function testNextRates(
    uint256 blockNumber,
    address _idleToken, 
    uint256[][] memory allocations
  ) internal returns (uint256[] memory aprs) {
    uint256 len = allocations.length;
    aprs = new uint256[](len);
    for (uint256 i = 0; i < len;) {
      // we need to reset the forked state after each rebalance
      vm.createSelectFork("mainnet", blockNumber);
      aprs[i] = getAprForAllocations(_idleToken, allocations[i]);
      unchecked {
        ++i;
      }
    }
  }

  function getAprForAllocations(
    address _idleToken, 
    uint256[] memory allocations
  ) internal returns (uint256) {
    IIdleToken it = IIdleToken(_idleToken);
    vm.prank(REBALANCER);
    it.setAllocations(allocations);
    it.rebalance();
    return it.getAvgAPR();
  }

  function testIdleUSDC(uint256 blockNumber, uint256[][] memory allocations) external returns (uint256[] memory) {
    return testNextRates(blockNumber, IDLE_USDC, allocations);
  }
  function testIdleDAI(uint256 blockNumber, uint256[][] memory allocations) external returns (uint256[] memory) {
    return testNextRates(blockNumber, IDLE_DAI, allocations);
  }
  function testIdleUSDT(uint256 blockNumber, uint256[][] memory allocations) external returns (uint256[] memory) {
    return testNextRates(blockNumber, IDLE_USDT, allocations);
  }
}