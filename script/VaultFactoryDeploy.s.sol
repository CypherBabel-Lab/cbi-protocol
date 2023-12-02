// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";
import { IVaultFactory } from "../src/vault-factory/IVaultFactory.sol";
import { IValueEvaluator } from "./interfaces/IValueEvaluator.sol";
import { ChainlinkPriceFeedMixin } from "../src/price-feeds/primitives/ChainlinkPriceFeedMixin.sol";

address constant WNATIVE_TOKEN = 0xf283c304b29c94385C01e77ef5E08160419D5760;
uint256 constant CHAINLINK_STALE_RATE_THRESHOLD = 365 * 5 days;

address constant WNATIVE_TOKEN_USD_AGGREGATOR = 0x229690c70c1Ef1DE9a66CeDd2cC0ae4fA845Ed9a;

// address primitive asset
address constant WBTC = 0x45485D89523721228dE3d032E92C15Ef2cC2fFe2;
address constant BTC_USD_AGGREGATOR = 0xd021Acf06a8f62F00242b7B51871c6136f5DD4eD;
address constant WETH = 0xBdA17499006dCBa50DF3A38101Ff0D42Dd4f5C52;
address constant ETH_USD_AGGREGATOR = 0xF6Ce9b321855FCA4CeAe6248B30eDBb605844266;
address constant WSOL = 0xBAAAC3CE2b6EBb5C5721866478c10F8E88DBfFFB;
address constant SOL_ETH_AGGREGATOR = 0x176278b95758559fca527052f4BD2E853248b7c6;
address constant DAI = 0x8D61BdC8891A66dFF842ae7F0f68D4a2c4c04Dd1;
address constant DAI_USD_AGGREGATOR = 0x229690c70c1Ef1DE9a66CeDd2cC0ae4fA845Ed9a;

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
        console.log("vaultFactoryAddress",vaultFactoryAddress);
        address vauleEvaluatorAddress = deployCode("ValueEvaluator.sol", abi.encode(vaultFactoryAddress, WNATIVE_TOKEN, CHAINLINK_STALE_RATE_THRESHOLD));
        console.log("vauleEvaluatorAddress",vauleEvaluatorAddress);
        address integrationManagerAddress = deployCode("IntegrationManager.sol", abi.encode(vaultFactoryAddress, vauleEvaluatorAddress));
        console.log("integrationManagerAddress",integrationManagerAddress);
        address globalSharedAddress = deployCode("GlobalShared.sol", abi.encode(vaultFactoryAddress, integrationManagerAddress, vauleEvaluatorAddress, WNATIVE_TOKEN));
        console.log("globalSharedAddress",globalSharedAddress);
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
 