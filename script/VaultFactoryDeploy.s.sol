// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { Script } from "forge-std/Script.sol";
import { IVaultFactory } from "../src/vault-factory/IVaultFactory.sol";
import { IValueEvaluator } from "./interfaces/IValueEvaluator.sol";
import { ChainlinkPriceFeedMixin } from "../src/price-feeds/primitives/ChainlinkPriceFeedMixin.sol";

address constant WNATIVE_TOKEN = 0x60Cd78c3edE4d891455ceAeCfA97EECD819209cF;
uint256 constant CHAINLINK_STALE_RATE_THRESHOLD = 365 * 5 days;

address constant WNATIVE_TOKEN_USD_AGGREGATOR = 0xC874f389A3F49C5331490145f77c4eFE202d72E1;

// address primitive asset
address constant WBTC = 0x4492081335788Dc2967c65f24772375e30C06fE3;
address constant BTC_USD_AGGREGATOR = 0x4b0687ce6eC3Fe6c019467c744D0C563643BdFa4;
address constant WETH = 0x10ea44f6a33107d2F9d2273d1C2F87aab271D214;
address constant ETH_USD_AGGREGATOR = 0xAEc43Fc8D4684b6A6577c3B18A1c1c6d3D55C28E;
address constant WSOL = 0x26b475D34Adf60d1d6F35c79029C087E1e749140;
address constant SOL_ETH_AGGREGATOR = 0x3C39209e85c1a27f1B992Bcf3416f5fC84764F2e;
address constant DAI = 0x7D026BCAb767F364EbFE5527c2EbD960dd495A8C;
address constant DAI_USD_AGGREGATOR = 0xdE2aA055F8DA4d2a4A5063b8736C8455AEa8aB3F;

enum ChainlinkRateAsset {
    ETH,
    USD
}
contract VaultFactoryDeploy is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        // deploy lib contract
        address guardianLogicAddress = deployCode("GuardianLogic.sol");
        address beaconGuardianLogicAddress = deployCode("Beacon.sol",abi.encode(guardianLogicAddress));
        address vaultLogicAddress = deployCode("VaultLogic.sol");
        address beaconVaultLogicAddress = deployCode("Beacon.sol",abi.encode(vaultLogicAddress));
        address vaultFactoryAddress = deployCode("VaultFactory.sol",abi.encode(beaconGuardianLogicAddress,beaconVaultLogicAddress));
        address vauleEvaluatorAddress = deployCode("ValueEvaluator.sol", abi.encode(vaultFactoryAddress, WNATIVE_TOKEN, CHAINLINK_STALE_RATE_THRESHOLD));
        address integrationManagerAddress = deployCode("IntegrationManager.sol", abi.encode(vaultFactoryAddress, vauleEvaluatorAddress));
        address globalSharedAddress = deployCode("GlobalShared.sol", abi.encode(vaultFactoryAddress, integrationManagerAddress, vauleEvaluatorAddress, WNATIVE_TOKEN));
        // set vault factory global shared
        IVaultFactory(vaultFactoryAddress).setGlobalShared(globalSharedAddress);
        // active vault factory
        IVaultFactory(vaultFactoryAddress).activate();
        // set value evaluator eth usd aggregator
        IValueEvaluator(vauleEvaluatorAddress).setEthUsdAggregator(WNATIVE_TOKEN_USD_AGGREGATOR);
        // set value evaluator primitives aggregator
        address[] memory erc20AddressList = new address[](4);
        erc20AddressList[0] = WBTC;
        erc20AddressList[1] = WETH;
        erc20AddressList[2] = WSOL;
        erc20AddressList[3] = DAI;
        address[] memory chainlinkAggregatorAddressList = new address[](4);
        chainlinkAggregatorAddressList[0] = BTC_USD_AGGREGATOR;
        chainlinkAggregatorAddressList[1] = ETH_USD_AGGREGATOR;
        chainlinkAggregatorAddressList[2] = SOL_ETH_AGGREGATOR;
        chainlinkAggregatorAddressList[3] = DAI_USD_AGGREGATOR;
        uint8[] memory rateAssetList = new uint8[](4);
        rateAssetList[0] = uint8(ChainlinkRateAsset.USD);
        rateAssetList[1] = uint8(ChainlinkRateAsset.USD);
        rateAssetList[2] = uint8(ChainlinkRateAsset.USD);
        rateAssetList[3] = uint8(ChainlinkRateAsset.USD);
        IValueEvaluator(vauleEvaluatorAddress).addPrimitives(erc20AddressList,chainlinkAggregatorAddressList,rateAssetList);
        vm.stopBroadcast();
    }
}
 