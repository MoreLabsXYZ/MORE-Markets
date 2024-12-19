// SPDX-License-Identifier: GNU General Public License v3.0 (GNU GPLv3)
pragma solidity ^0.8.0;

import {IInternetBondRatioFeed} from './interfaces/IInternetBondRatioFeed.sol';
import {AggregatorV2V3Interface} from './interfaces/AggregatorV2V3Interface.sol';

/**
 * @title A port of the ChainlinkAggregatorV3 interface that supports AnkrRationFeed
 * @notice This does not store any roundId information on-chain. Please review the code before using this implementation.
 * This smart contract supposed to behave like a Chainlink's oracle and return the price of ankrFlow/usd
 */
contract AnkrFlowToUsdFeed is AggregatorV2V3Interface {
  IInternetBondRatioFeed public ankrRatioFeed;
  address public ankrFlow;
  AggregatorV2V3Interface public flowFeed;

  constructor(address _ankrRatioFeed, address _ankrFlow, address _flowFeed) {
    ankrRatioFeed = IInternetBondRatioFeed(_ankrRatioFeed);
    ankrFlow = _ankrFlow;
    flowFeed = AggregatorV2V3Interface(_flowFeed);
  }

  function decimals() public view virtual returns (uint8) {
    return uint8(8);
  }

  function description() public pure returns (string memory) {
    return 'Feed that provides price of the AnkrFlow in USD';
  }

  function version() public pure returns (uint256) {
    return 1;
  }

  function latestAnswer() public view virtual returns (int256) {
    int256 answer = _getPriceOfAnkrFlowInUsd();
    return answer;
  }

  function latestTimestamp() public view returns (uint256) {
    return block.timestamp;
  }

  function latestRound() public view returns (uint256) {
    return latestTimestamp();
  }

  function getAnswer(uint256) public view returns (int256) {
    return latestAnswer();
  }

  function getTimestamp(uint256) external view returns (uint256) {
    return latestTimestamp();
  }

  function getRoundData(
    uint80 _roundId
  ) external view returns (uint80, int256, uint256, uint256, uint80) {
    int256 answer = _getPriceOfAnkrFlowInUsd();
    return (_roundId, answer, latestTimestamp(), latestTimestamp(), _roundId);
  }

  function latestRoundData() external view returns (uint80, int256, uint256, uint256, uint80) {
    int256 answer = _getPriceOfAnkrFlowInUsd();
    return (
      uint80(latestTimestamp()),
      answer,
      latestTimestamp(),
      latestTimestamp(),
      uint80(latestTimestamp())
    );
  }

  function _getSafeRatioForAnkrFlow() internal view returns (uint256 ratio) {
    ratio = ankrRatioFeed.getRatioFor(ankrFlow);

    if (ratio > 1e18) ratio = 1e18;
  }

  function _getPriceOfAnkrFlowInUsd() internal view returns (int256) {
    int256 flowAnkrFlowPrice = int256(_getSafeRatioForAnkrFlow());
    int256 flowPriceInUsd = flowFeed.latestAnswer();

    // Since AnkrRatioFeed returns price of 1 FLOW in AnkrFlow, we have to convert it.
    // Price of AnkrFlow in FLOW is
    //
    // ankrFlowFlowPrice = 1 / flowAnkrFlowPrice
    //
    // Then to convert it to USD we need to multiply it with price of FLOW in USD
    //
    // flowPriceInUsd * ankrFlowFlowPrice
    //
    // or
    //
    // flowPriceInUsd / flowAnkrFlowPrice

    // Decimal of flowPriceInUsd is 8, that means that we need to convert it to 18 decimal
    // by multiplying by 10**(18 - 8) and then multiply by 10**8 to safe precision and keep
    // decimal of usd.
    return (flowPriceInUsd * 10 ** 10 * 10 ** 8) / flowAnkrFlowPrice;
  }
}
