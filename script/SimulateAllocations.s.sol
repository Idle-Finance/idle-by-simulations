// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/console.sol";
import {Script} from "forge-std/Script.sol";
import {IIdleToken} from "../src/IIdleToken.sol";

contract SimulateAllocations is Script {
  address public constant REBALANCER  = 0xB3C8e5534F0063545CBbb7Ce86854Bf42dB8872B;
  // @notice run with
  // forge script ./script/SimulateAllocations.s.sol:SimulateAllocations --fork-url $TENDERLY_RPC_URL_2 -v --sig "testIdleDAI(uint256[][])" "[[100000,0,0],[0,100000,0]]"
  function testNextRates(
    address _idleToken, 
    uint256[][] memory allocations
  ) public returns (uint256[] memory aprs) {
    aprs = new uint256[](allocations.length);
    for (uint256 i = 0; i < allocations.length; i++) {
      // logArray("allocations", allocations[i]);
      aprs[i] = getAprForAllocations(_idleToken, allocations[i]);
      // console.log("apr", aprs[i]);
      // console.log('---');
    }
  }

  function getAprForAllocations(
    address _idleToken, 
    uint256[] memory allocations
  ) public returns (uint256) {
    IIdleToken it = IIdleToken(_idleToken);

    vm.prank(REBALANCER);
    it.setAllocations(allocations);
    it.rebalance();
    return it.getAvgAPR();
  }

  function testIdleUSDC(uint256[][] memory allocations) public returns (uint256[] memory aprs) {
    return testNextRates(0x5274891bEC421B39D23760c04A6755eCB444797C, allocations);
  }
  function testIdleDAI(uint256[][] memory allocations) public returns (uint256[] memory aprs) {
    return testNextRates(0x3fE7940616e5Bc47b0775a0dccf6237893353bB4, allocations);
  }
  function testIdleUSDT(uint256[][] memory allocations) public returns (uint256[] memory aprs) {
    return testNextRates(0xF34842d05A1c888Ca02769A633DF37177415C2f8, allocations);
  }

  function logArray(string memory label, uint256[] memory arr) internal view {
    for (uint256 i = 0; i < arr.length; i++) {
      console.log(label, i, arr[i]);
    }
  }
}