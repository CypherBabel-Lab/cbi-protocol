// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";

// integrationManagerAddress (from VaultFactoryDeploy)
address constant IntergrationManagerAddress = 0xe9Af0A430134E6648F636b3F08f67336eF14cF85;

//uniswap v2
address constant UNISWAP_V2_FACTORY = 0xaF4c3cB96c011Bd123a5aeB7C8eaf5E17f5Ca080;
address constant UNISWAP_V2_ROUTER_02 = 0xC0FcE24e33DB355e21d63eb91Fd35D8F65D0A1DE;


contract AdapterDeploy is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        // deploy uniswap v2 adapter
        address adapterUniV2ExchangeAddress = deployCode("UniswapV2ExchangeAdapter.sol", abi.encode(IntergrationManagerAddress, UNISWAP_V2_ROUTER_02));
        console.log("adapterUniV2ExchangeAddress",adapterUniV2ExchangeAddress);
        address adapterUniV2LPAddress = deployCode("UniswapV2LiquidityAdapter.sol", abi.encode(IntergrationManagerAddress, UNISWAP_V2_ROUTER_02, UNISWAP_V2_FACTORY));
        console.log("adapterUniV2LPAddress",adapterUniV2LPAddress);
        vm.stopBroadcast();
    }
}