# dss-glow
smolbrain execution of a permissionless contract to make it easy to send GUSD to the `vow`, or surplus buffer.

This is the same as @lollike 's [lollike/dss-blow](https://github.com/lollike/dss-blow), but for GUSD, hence the name `glow`.

## Functionality

### `glow()`
Calling the `glow()` function will automatically `sellGem` any GUSD deposited in the contract through the `DssPsm` for GUSD, followed by a `join` on the resulting Dai to the `vow`.
Therefore in order to contribute GUSD permissionlessly to the Maker surplus buffer, you simply send GUSD to the Glow contract, and subsequentially call `glow()`.

### `glow(uint256 amt_)`
You can also call `glow(uint256 amt_)` to send a specified amount of GUSD directly from your wallet to the Maker surplus buffer. To do this, you must first approve Glow to spend your GUSD.

### `quit()`
Calling `quit()` will sweep any GUSD balance to the Maker Pause Proxy, just in case.

## Deployment

- [Mainnet]()
- [Goerli]()

Contract to send GUSD from the outside to MakerDAO's surplus buffer in a permissionless way.