# dss-glow
smolbrain execution of a permissionless contract to make it easy to send GUSD to the `vow`, or surplus buffer.

This is the same as @lollike 's [lollike/dss-blow](https://github.com/lollike/dss-blow), but for GUSD, hence the name `glow`.

## Functionality

### `glow()`
Calling the `glow()` function will automatically `sellGem` any GUSD deposited in the contract through the `DssPsm` for GUSD, followed by a `join` on the resulting Dai to the `vow`.
Therefore in order to contribute GUSD permissionlessly to the Maker surplus buffer, you simply send Dai to the DssBlow contract, and subsequentially call `blow()`.

### `glow(uint256 amt_)`
You can also call `glow(uint256 amt_)` to send a specified amount of GUSD directly from your wallet to the Maker surplus buffer. To do this, you must first approve Glow to spend your Dai.

## Deployment

- [Mainnet]()
- [Goerli](https://goerli.etherscan.io/address/0x52228370b2cb60cb38a324a97a1e987c1aab7c75#code)

Contract to send GUSD from the outside to MakerDAO's surplus buffer in a permissionless way.