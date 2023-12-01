// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.19;

interface IDeployment {
    struct VaultFactoryConf {
        address weth;
        address globalShared;
        address ethUsdAggregator;
        uint256 chainlinkStaleRateThreshold;
        bool active;
    }
}