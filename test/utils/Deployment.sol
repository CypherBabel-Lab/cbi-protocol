// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.19;

import { Test } from "forge-std/Test.sol";
import { IVaultFactory } from "../../src/vault-factory/IVaultFactory.sol";
import { IValueEvaluator } from "../interfaces/IValueEvaluator.sol";
import { IDeployment } from "../interfaces/IDeployment.sol";


abstract contract Deployment is Test {

    function deployRelease(
        address weth,
        address ethUsdAggregator,
        uint256 chainlinkStaleRateThreshold
    ) internal returns (IDeployment.VaultFactoryConf memory conf) {
        address vaultFactoryAddress = deployVaultFactory();
        address vauleEvaluatorAddress = deployVauleEvaluator(vaultFactoryAddress, weth, chainlinkStaleRateThreshold);
        address integrationManagerAddress = deployIntegrationManager(vaultFactoryAddress, vauleEvaluatorAddress);
        address globalSharedAddress = deployGlobalShared(vaultFactoryAddress, integrationManagerAddress, vauleEvaluatorAddress, weth);
        IVaultFactory(vaultFactoryAddress).setGlobalShared(globalSharedAddress);
        IVaultFactory(vaultFactoryAddress).activate();
        IValueEvaluator(vauleEvaluatorAddress).setEthUsdAggregator(ethUsdAggregator);
        conf = IDeployment.VaultFactoryConf({
            weth: weth,
            globalShared: globalSharedAddress,
            ethUsdAggregator: ethUsdAggregator,
            chainlinkStaleRateThreshold: chainlinkStaleRateThreshold,
            active: true
        });
        return conf;
    }

    function deployVaultLogic() internal returns (address vaultLogic) {
        address vaultLogicAddress = deployCode("VaultLogic.sol");
        address beaconVaultLogicAddress = deployCode("Beacon.sol",abi.encode(vaultLogicAddress));
        return beaconVaultLogicAddress;
    }

    function deployGuardianLogic() internal returns (address guardianLogic) {
        address guardianLogicAddress = deployCode("GuardianLogic.sol");
        address beaconGuardianLogicAddress = deployCode("Beacon.sol",abi.encode(guardianLogicAddress));
        return beaconGuardianLogicAddress;
    }

    function deployVaultFactory() internal returns (address vaultFactory) {
        address beaconGuardianLogicAddress = deployGuardianLogic();
        address beaconVaultLogicAddress = deployVaultLogic();
        address vaultFactoryAddress = deployCode("VaultFactory.sol",abi.encode(beaconGuardianLogicAddress,beaconVaultLogicAddress));
        return vaultFactoryAddress;
    }

    function deployVauleEvaluator(address vaultFactoryAddress, address wethToken, uint256 chainlinkStaleRateThreshold) internal returns (address vauleEvaluator) {
        address vauleEvaluatorAddress = deployCode("ValueEvaluator.sol", abi.encode(vaultFactoryAddress, wethToken, chainlinkStaleRateThreshold));
        return vauleEvaluatorAddress;
    }

    function deployIntegrationManager(address vaultFactoryAddress, address vauleEvaluatorAddress) internal returns (address integrationManager) {
        address integrationManagerAddress = deployCode("IntegrationManager.sol", abi.encode(vaultFactoryAddress, vauleEvaluatorAddress));
        return integrationManagerAddress;
    }

    function deployGlobalShared(address vaultFactoryAddress, address integrationManagerAddress, address vauleEvaluatorAddress, address wethToken) internal returns (address globalShared) {
        address globalSharedAddress = deployCode("GlobalShared.sol", abi.encode(vaultFactoryAddress, integrationManagerAddress, vauleEvaluatorAddress, wethToken));
        return globalSharedAddress;
    }
}