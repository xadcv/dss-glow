// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../lib/forge-std/src/Test.sol";
import "../src/Glow.sol";

interface RestrictedTokenFaucet {
    function gulp(address gem, address[] calldata addrs) external;
}

interface Vat {
    function dai(address usr) external returns (uint256);

    function sin(address usr) external returns (uint256);
}

contract GlowTest is Test {
    uint256 dec18 = 10**18;
    uint256 dec02 = 10**2;
    uint256 dec45 = 10**45;

    ChainLogLike constant changelog =
        ChainLogLike(0xdA0Ab1e0017DEbCd72Be8599041a2aa3bA7e740F);
    RestrictedTokenFaucet constant rtf =
        RestrictedTokenFaucet(0xa473CdDD6E4FAc72481dc36f39A409D86980D187);

    address[] testers = [address(1), address(2)];

    Glow public glow;
    Gusd gusd = Gusd(changelog.getAddress("GUSD"));
    Dai dai = Dai(changelog.getAddress("MCD_DAI"));
    Vat vat = Vat(changelog.getAddress("MCD_VAT"));
    address vow = changelog.getAddress("MCD_VOW");

    uint256 goerliFork;
    string GOERLI_RPC_URL = vm.envString("GOERLI_RPC_URL");

    function setUp() public {
        goerliFork = vm.createFork(GOERLI_RPC_URL);

        glow = new Glow(changelog.getAddress("CHANGELOG"));

        rtf.gulp(changelog.getAddress("GUSD"), testers);
    }

    function testGusdBalanceOnContract() public {
        assertEq(gusd.balanceOf(address(1)), 50_000 * dec02);
    }

    //Approve Glow contract as the GUSD spender
    function testGusdTransferToGlow() public {
        vm.prank(address(glow)); // msg.sender
        gusd.approve(address(this), 2**256 - 1); // Glow asking for approval to spend GUSD from msg.sender

        vm.prank(address(1));
        gusd.transfer(address(glow), 50_000 * dec02);

        assertEq(gusd.balanceOf(address(glow)), 50_000 * dec02);
    }

    //Without Approval of Glow contract as the GUSD spender
    function testGusdTransferToGlowWithoutApproval() public {
        vm.expectRevert("ds-token-insufficient-approval");

        gusd.transferFrom(address(1), address(glow), 50_000 * dec02);
    }

    function testGUSDJoinApproval() public {
        // Approves JOIN to spend GUSD from this
        assertEq(
            gusd.allowance(
                address(glow),
                changelog.getAddress("MCD_JOIN_PSM_GUSD_A")
            ),
            2**256 - 1
        );
    }

    function testSellGemWorks() public {
        int256 surplusBefore = int256(vat.dai(vow)) - int256(vat.sin(vow));
        vm.prank(address(1));
        gusd.approve(address(glow), 5 * dec02);

        vm.prank(address(1));
        glow.glow(5 * dec02);

        int256 surplusAfter = int256(vat.dai(vow)) - int256(vat.sin(vow));

        assertEq(surplusBefore + int256(5 * dec45), surplusAfter);
    }

    function testBalanceSweep() public {
        int256 surplusBefore = int256(vat.dai(vow)) - int256(vat.sin(vow));
        vm.prank(address(2));
        gusd.transfer(address(glow), 5 * dec02);

        vm.prank(address(1));
        gusd.transfer(address(glow), 10 * dec02);

        vm.prank(address(3));
        glow.glow();

        int256 surplusAfter = int256(vat.dai(vow)) - int256(vat.sin(vow));

        assertEq(surplusBefore + int256(15 * dec45), surplusAfter);
    }

    function testBalanceSweepMultiple() public {
        int256 surplusBefore = int256(vat.dai(vow)) - int256(vat.sin(vow));
        vm.prank(address(2));
        gusd.transfer(address(glow), 5 * dec02);

        vm.prank(address(3));
        glow.glow();

        vm.prank(address(1));
        gusd.transfer(address(glow), 10 * dec02);

        vm.prank(address(4));
        glow.glow();

        int256 surplusAfter = int256(vat.dai(vow)) - int256(vat.sin(vow));

        assertEq(surplusBefore + int256(15 * dec45), surplusAfter);
    }

    function testSurplusBeforeAfter() public {
        int256 surplusBefore = int256(vat.dai(vow)) - int256(vat.sin(vow));

        vm.prank(address(1));
        gusd.transfer(address(glow), 10 * dec02);

        vm.prank(address(4));
        glow.glow();

        int256 surplusAfter = int256(vat.dai(vow)) - int256(vat.sin(vow));

        assertEq(surplusBefore + int256(10 * dec45), surplusAfter);
    }

    function testOnlySendAmt() public {
        int256 surplusBefore = int256(vat.dai(vow)) - int256(vat.sin(vow));

        vm.prank(address(2));
        gusd.transfer(address(glow), 5 * dec02);

        vm.prank(address(1));
        gusd.approve(address(glow), 10 * dec02);

        vm.prank(address(1));
        glow.glow(10 * dec02);

        int256 surplusAfter = int256(vat.dai(vow)) - int256(vat.sin(vow));

        assertEq(surplusBefore + int256(10 * dec45), surplusAfter);
    }

}
