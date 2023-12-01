// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { Script } from "forge-std/Script.sol";

// integrationManagerAddress (from VaultFactoryDeploy)
address constant IntergrationManagerAddress = 0x79841BFF57F826aB6F1AE8dBC68a564375AA878F;

//uniswap v2
address constant UNISWAP_V2_FACTORY = 0x79841BFF57F826aB6F1AE8dBC68a564375AA878F;
address constant UNISWAP_V2_ROUTER_02 = 0xB1C4C22FeE13DA89E8D983227d9dc6314E29894a;


contract AdapterDeploy is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        // deploy uniswap v2 adapter
        address adapterUniV2ExchangeAddress = deployCode("UniswapV2ExchangeAdapter.sol", abi.encode(IntergrationManagerAddress, UNISWAP_V2_ROUTER_02));
        address adapterUniV2LPAddress = deployCode("UniswapV2LiquidityAdapter.sol", abi.encode(IntergrationManagerAddress, UNISWAP_V2_ROUTER_02, UNISWAP_V2_FACTORY));
        vm.stopBroadcast();
    }
}