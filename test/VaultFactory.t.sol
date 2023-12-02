// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.19;

import { Test } from "forge-std/Test.sol";
import { IVaultFactory } from "./interfaces/IVaultFactory.sol";

contract VaultFactory is Test {
    function setUp() public {
    }

    function testGetOwnerSuccess() public {
        address creator = makeAddr("FundDeployerCreator");
        // Deploy a new FundDeployer from an expected account
        vm.prank(creator);
        address beaconGuardianLogicAddress =  makeAddr("BeaconGuardianLogic");
        address beaconVaultLogicAddress =  makeAddr("BeaconVaultLogic");
        address vaultFactoryAddress = deployCode("VaultFactory.sol",abi.encode(beaconGuardianLogicAddress,beaconVaultLogicAddress));

        assertEq(IVaultFactory(vaultFactoryAddress).getCreator(), creator);
        assertEq(IVaultFactory(vaultFactoryAddress).getOwner(), creator);
        assertEq(IVaultFactory(vaultFactoryAddress).isActivated(), false);
    }

    function testCreateNewFundWithNotActivated() public {
        address creator = makeAddr("FundDeployerCreator");
        // Deploy a new FundDeployer from an expected account
        vm.startPrank(creator);
        address beaconGuardianLogicAddress =  makeAddr("BeaconGuardianLogic");
        address beaconVaultLogicAddress =  makeAddr("BeaconVaultLogic");
        address vaultFactoryAddress = deployCode("VaultFactory.sol",abi.encode(beaconGuardianLogicAddress,beaconVaultLogicAddress));
        vm.stopPrank();

        address fundCreator = makeAddr("fundCreator");
        vm.expectRevert("contract is not yet activate");
        vm.prank(fundCreator);
        IVaultFactory(vaultFactoryAddress).createNewVault("testVault", "TEST_VAULT", address(0), 0);
    }
}