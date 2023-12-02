// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.19;

import { Test } from "forge-std/Test.sol";
import { IDeployment } from "../interfaces/IDeployment.sol";
import { IERC20 } from "openzeppelin/token/ERC20/IERC20.sol";
import { IGuardianLogic } from "../interfaces/IGuardianLogic.sol";
import { IVaultLogic } from "../../src/vault/IVaultLogic.sol";
import { IGlobalShared } from "../../src/utils/IGlobalShared.sol";
import { IVaultFactory } from "../interfaces/IVaultFactory.sol";

contract FundUtil is Test{
    function createFund(
        IDeployment.VaultFactoryConf memory _factory,
        address _denominationAsset,
        uint256 _shareActionTimelock
    ) internal returns (IGuardianLogic guardianLogicProxy, IVaultLogic vaultLogicProxy) {
        (address guardianLogicAddress, address vaultLogicAddress) = _factory.vaultFactory.createNewVault(
            "testVault",
            "TEST_VAULT",
            _denominationAsset,
            _shareActionTimelock
        );
        guardianLogicProxy = IGuardianLogic(guardianLogicAddress);
        vaultLogicProxy = IVaultLogic(vaultLogicAddress);
    }

    function buyShares(address _sharesBuyer, IGuardianLogic guardianLogicProxy, uint256 _amountToDeposit)
        internal
        returns (uint256 sharesReceived_)
    {
        IERC20 denominationAsset = IERC20(guardianLogicProxy.getDenominationAsset());
        deal(address(denominationAsset), _sharesBuyer, _amountToDeposit);

        vm.startPrank(_sharesBuyer);
        denominationAsset.approve(address(guardianLogicProxy), _amountToDeposit);
        sharesReceived_ = guardianLogicProxy.buyShares({_investmentAmount: _amountToDeposit, _minSharesQuantity: 1});
        vm.stopPrank();
    }
}