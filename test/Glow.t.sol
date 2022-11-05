// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../lib/forge-std/src/Test.sol";
import "../src/Glow.sol";

interface RestrictedTokenFaucet {
    function gulp(address gem, address[] calldata addrs) external;
}

/*interface Vat {
    function join(address usr, uint256 wad) external;
}*/

contract GlowTest is Test {
    ChainLogLike constant changelog =
        ChainLogLike(0xdA0Ab1e0017DEbCd72Be8599041a2aa3bA7e740F);
    RestrictedTokenFaucet constant rtf =
        RestrictedTokenFaucet(0xa473CdDD6E4FAc72481dc36f39A409D86980D187);

    address[] testers = [address(1)];

    Glow public glow;

    uint256 goerliFork;
    string GOERLI_RPC_URL = vm.envString("GOERLI_RPC_URL");

    function setUp() public {
        goerliFork = vm.createFork(GOERLI_RPC_URL);

        glow = new Glow(changelog.getAddress("CHANGELOG"));

        rtf.gulp(changelog.getAddress("GUSD"), testers);
    }

    function testGusdBalanceOnContract() public {
        Gusd gusd = Gusd(changelog.getAddress("GUSD"));
        assertEq(gusd.balanceOf(address(1)), 50_000_00);
    }

    //Approve Glow contract as the GUSD spender
    function testGusdTransferToGlow() public {
        Gusd gusd = Gusd(changelog.getAddress("GUSD"));
        vm.prank(address(1)); // msg.sender
        gusd.approve(address(this), 2**256 - 1); // Glow asking for approval to spend GUSD from msg.sender

        vm.prank(address(1));
        gusd.transfer(address(this), 50_000_00);

        assertEq(gusd.balanceOf(address(this)), 50_000_00);
    }

    //Without Approval of Glow contract as the GUSD spender
    function testGusdTransferToGlowWithoutApproval() public {
        Gusd gusd = Gusd(changelog.getAddress("GUSD"));
        vm.expectRevert("ds-token-insufficient-approval");
        gusd.transferFrom(address(1), address(this), 50_000_00);
    }

    function testGUSDwithMcdJoinPSM() public {
        Gusd gusd = Gusd(changelog.getAddress("GUSD"));
        gusd.approve(changelog.getAddress("MCD_JOIN_PSM_GUSD_A"), 50_000_00);
        // Approves JOIN to spend GUSD from this
        assertEq(
            gusd.allowance(
                address(this),
                changelog.getAddress("MCD_JOIN_PSM_GUSD_A")
            ),
            50_000_00
        );
    }

    //Testing with Less Approval amt and checking the allowance
    function testGUSDwithMcdJoinPSMWithAmtLess() public {
        Gusd gusd = Gusd(changelog.getAddress("GUSD"));
        gusd.approve(changelog.getAddress("MCD_JOIN_PSM_GUSD_A"), 40_000_00);
        vm.expectRevert("ds-token-insufficient-approval");
        gusd.transferFrom(address(1), address(this), 50_000_00);
    }

    function testSellGemWorks() public {
        Dai dai = Dai(changelog.getAddress("MCD_DAI"));
        Gusd gusd = Gusd(changelog.getAddress("GUSD"));

        vm.prank(address(1));
        gusd.approve(address(glow), 5_00);
        
        vm.prank(address(1));
        glow.glow(5_00);

        assertEq(dai.balanceOf(address(this)), 5_000_000_000_000_000_000);
    }
}
