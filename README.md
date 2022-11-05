# dss-glow
smolbrain execution of a permissionless contract to make it easy to send GUSD to the `vow`, or surplus buffer.

This is the same as lollike's [lollike/dss-blow](https://github.com/lollike/dss-blow), but for GUSD, hence the name `glow`.

## Functionality

### `glow()`
Calling the `glow()` function will automatically `sellGem` any GUSD deposited in the contract through the `DssPsm` for GUSD, followed by a `join` on the resulting Dai to the `vow`.
Therefore in order to contribute GUSD permissionlessly to the Maker surplus buffer, you simply send Dai to the DssBlow contract, and subsequentially call `blow()`.

### `glow(uint256 wad)`
You can also call `blow(uint256 wad)` to send a specified amount of Dai directly from your wallet to the Maker surplus buffer. To do this, you must first approve DssBlow to spend your Dai.

## Deployment

- [Mainnet](https://etherscan.io/address/0x0048fc4357db3c0f45adea433a07a20769ddb0cf#code)
- [Goerli](https://goerli.etherscan.io/address/0x5db4d1be83ee0dac45e0cc2e5565a19d9c428daf#code)

Contract to send GUSD from the outside to MakerDAO's surplus buffer in a permissionless way.


## Reference Contracts Goerli

* Goerli Chainlog: 0xdA0Ab1e0017DEbCd72Be8599041a2aa3bA7e740F
* Goerli faucet: 0xa473CdDD6E4FAc72481dc36f39A409D86980D187
* Goerli GUSD: 0x67aef79654d8f6cf44fdc08949c308a4f6b3c45b
* Goerli GUSD PSM: 0x3b2dbe6767fd8b4f8334ce3e8ec3e2df8ab3957b
* Goerli GUSD Join: 0x4115fda246e2583b91ad602213f2ac4fc6e437ca
* Goerli DAI: 0x11fe4b6ae13d2a6055c8d9cf65c55bac32b5d844
* Goerli DAI Join: 0x6a60b7070befb2bfc964f646efdf70388320f4e0
* Goerli VOW: 0x23f78612769b9013b3145E43896Fa1578cAa2c2a
* Goerli VAT: 0xb966002ddaa2baf48369f5015329750019736031

## Reference Contracts 

* Mainnet GUSD: 0x056Fd409E1d7A124BD7017459dFEa2F387b6d5Cd
* Mainnet GUSD PSM: 0x204659B2Fd2aD5723975c362Ce2230Fba11d3900
* Mainnet GUSD Join: 0xe29A14bcDeA40d83675aa43B72dF07f649738C8b
* Mainnet DAI: 0x6B175474E89094C44Da98b954EedeAC495271d0F
* Mainnet DAI Join: 0x9759A6Ac90977b93B58547b4A71c78317f391A28
* Mainnet VOW: 0xA950524441892A31ebddF91d3cEEFa04Bf454466
* Mainnet VAT: 0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B

// Goerli constructor args: 0x6a60b7070befb2bfc964f646efdf70388320f4e0, 0x67aef79654d8f6cf44fdc08949c308a4f6b3c45b, 0x4115fda246e2583b91ad602213f2ac4fc6e437ca, 0x3b2dbe6767fd8b4f8334ce3e8ec3e2df8ab3957b, 0x23f78612769b9013b3145E43896Fa1578cAa2c2a
// Mainnet constructor args: 0x9759A6Ac90977b93B58547b4A71c78317f391A28 0x056Fd409E1d7A124BD7017459dFEa2F387b6d5Cd 0xe29A14bcDeA40d83675aa43B72dF07f649738C8b 0x204659B2Fd2aD5723975c362Ce2230Fba11d3900 0xA950524441892A31ebddF91d3cEEFa04Bf454466