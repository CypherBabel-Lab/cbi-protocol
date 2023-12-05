# New-Horizon-contracts

# test
```bash
forge test
```

# deploy contract

deployed test uniswap v2(important: need to change the init code hash in lib/uniswapv2/src/libraries/UniswapV2Library.sol)
```bash
forge script ./script/UniswapV2Deploy.s.sol --skip-simulation --rpc-url https://rpc-evm-sidechain.xrpl.org --broadcast --slow -vvv
```

deployed test environment (include test erc20 token and mock chainlink price feed)(change UNISWAP_V2_ROUTER_02 from previous step)
```bash
forge script ./script/EnvironmentDeploy.s.sol --skip-simulation --rpc-url https://rpc-evm-sidechain.xrpl.org --broadcast --slow -vvv
```

deployed test vaultFactory (change all the constant address from previous step)
```bash
forge script ./script/VaultFactoryDeploy.s.sol --skip-simulation --rpc-url https://rpc-evm-sidechain.xrpl.org --broadcast --slow -vvv
```

deployed test uniswapv2 adapter (change all the constant address from previous step)
```bash
forge script ./script/AdapterDeploy.s.sol --skip-simulation --rpc-url https://rpc-evm-sidechain.xrpl.org --broadcast --slow -vvv
```

# current deployed address
```
WXRP: 0xfDaF44799BA8fa3DC6af978ea142B7101c17CDD9
UNISWAPV2_ROUTER_02: 0x722f41d377caf139619ab365A27da1018a74901e
UNISWAPV2_FACTORY: 0xc871b0b1c10F40059512F2DA2cD37255e6a9ae54

WBTC: 0x9aF7D95036e2516E2c3149b79A8992345d56F80B
WETH: 0x83Ff9c342388e77eE480Ffa262A5a0E52536fFcc
WSOL: 0x73aaB0aef913eA76d5EA81c61BC31fe76023cC4f
DAI: 0xEBeB6B2744469111dBA0e5B0C7FBdC88c1427544

WBTC/USD: 0x5CA4db2bB728b0d6285A9C83d43F7503Dca12e92
WETH/USD: 0x46BAFFad74F525f5D3eaCE0e7D94A3A74a224eFa
WSOL/USD: 0xf283c304b29c94385C01e77ef5E08160419D5760
DAI/USD: 0xaF4c3cB96c011Bd123a5aeB7C8eaf5E17f5Ca080

WXRP/USD: 0xC0FcE24e33DB355e21d63eb91Fd35D8F65D0A1DE

vaultFactory: 0x28703Bde2b910Ea546022a31A0C956f4C7eD2023
vauleEvaluator: 0x32d179473bCa75eDFD75207839D451946136ba60
integrationManager: 0x8F025faeF26c649e5D093677dFf7dfC023e78f31

adapterUniswapV2Exchange: 0x3a9d736b6A5A0f2B5741B918bdC778cE4E9A795b
adapterUniswapV2LP: 0x1c695826A3de028CE8de574F731f3D37F9b338cA
```