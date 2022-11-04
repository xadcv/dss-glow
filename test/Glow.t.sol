// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Glow.sol";

interface ChainLogLike {
    function getAddress(bytes32) external view returns (address);
}

contract GlowTest is Test {
    ChainLogLike constant changelog =
        ChainLogLike(0xdA0Ab1e0017DEbCd72Be8599041a2aa3bA7e740F);
    Glow public glow;
    uint256 goerliFork;

    string GOERLI_RPC_URL = vm.envString("GOERLI_RPC_URL");

    function setUp() public {
        goerliFork = vm.createFork(GOERLI_RPC_URL);

        Glow glow = new Glow();
    }

    function testGusdAddress() public {
        address gusd = changelog.getAddress("GUSD");
        assertEq(gusd, 0x67aeF79654D8F6CF44FdC08949c308a4F6b3c45B);
    }
}
