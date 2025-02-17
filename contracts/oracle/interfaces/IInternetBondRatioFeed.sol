// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.7;

/// AnkrRatioFeed interface.

interface IInternetBondRatioFeed {
    function updateRatioBatch(
        address[] calldata addresses,
        uint256[] calldata ratios
    ) external;

    function getRatioFor(address) external view returns (uint256);

    function updateRatio(address addr, uint256 ratio) external;
}
