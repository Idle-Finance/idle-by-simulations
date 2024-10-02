// SPDX-License-Identifier: Apache-2.0
/**
 * @title: Idle Token interface
 * @author: Idle Labs Inc., idle.finance
 */
pragma solidity ^0.8.13;

interface IIdleToken {
  function rebalance() external returns (bool);
  function getAvgAPR() external view returns (uint256);
  function setAllocations(uint256[] calldata _allocations) external;
}
