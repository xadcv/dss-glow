// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Glow.sol";

interface RestrictedTokenFaucet {
    function gulp(address gem, address[] calldata addrs) external;
}

contract GlowTest is Test {
    ChainLogLike constant changelog =
        ChainLogLike(0xdA0Ab1e0017DEbCd72Be8599041a2aa3bA7e740F);
    RestrictedTokenFaucet constant rtf =
        RestrictedTokenFaucet(0xa473CdDD6E4FAc72481dc36f39A409D86980D187);

    address[] testers = [address(this)];

    Glow public glow;

    uint256 goerliFork;
    string GOERLI_RPC_URL = vm.envString("GOERLI_RPC_URL");

    function setUp() public {
        goerliFork = vm.createFork(GOERLI_RPC_URL);
        glow = new Glow(changelog.getAddress("CHANGELOG"));
        rtf.gulp(changelog.getAddress("GUSD"), testers);
    }

    function testGusdBalance() public {
        Gusd gusd = Gusd(changelog.getAddress("GUSD"));
        assertEq(gusd.balanceOf(address(this)), 50_000_00);
    }
}
