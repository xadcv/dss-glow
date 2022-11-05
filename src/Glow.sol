// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface Gusd {
    function balanceOf(address _owner) external view returns (uint256);

    function approve(address _addr, uint256 _amt) external returns (bool);

    function transfer(address _to, uint256 _value) external returns (bool);

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) external returns (bool);

    function allowance(address _owner, address _spender)
        external
        returns (uint256);
}

interface Dai {
    function balanceOf(address) external returns (uint256);

    function approve(address usr, uint256 wad) external returns (bool);

    function transferFrom(
        address src,
        address dst,
        uint256 wad
    ) external returns (bool);

    function allowance(address _owner, address _spender)
        external
        returns (uint256);
}

interface DssPsm {
    function sellGem(address usr, uint256 gemAmt) external;
}

interface DaiJoin {
    function join(address usr, uint256 wad) external;
}

interface ChainLogLike {
    function getAddress(bytes32) external view returns (address);
}

contract Glow {
    ChainLogLike public immutable changelog;
    Gusd public immutable gusd;
    Dai public immutable dai;
    DssPsm public immutable gusdPsm;
    DaiJoin public immutable daiJoin;

    address gusdAddress;
    address daiAddress;
    address gusdPsmAddress;
    address gusdJoinAddress;
    address daiJoinAddress;
    address vow;

    constructor(address chainlog_) {
        changelog = ChainLogLike(chainlog_);

        gusdAddress     = changelog.getAddress("GUSD");
        daiAddress      = changelog.getAddress("MCD_DAI");
        gusdPsmAddress  = changelog.getAddress("MCD_PSM_GUSD_A");
        gusdJoinAddress = changelog.getAddress("MCD_JOIN_PSM_GUSD_A");
        daiJoinAddress  = changelog.getAddress("MCD_JOIN_DAI");
        vow             = changelog.getAddress("MCD_VOW");

        gusd = Gusd(gusdAddress);
        dai = Dai(daiAddress);
        gusdPsm = DssPsm(gusdPsmAddress);
        daiJoin = DaiJoin(daiJoinAddress);

        // Step 1: MCD_JOIN_PSM_GUSD_A approval to spend GUSD from Glow
        gusd.approve(gusdJoinAddress, 2**256 - 1);
        
        //dai.approve()
    }

    /// @dev Pulls GUSD from the wallet of the user
    function glow(uint256 amt_) public {
        // Step 0: Increase to the maximum limit the GUSD spender on Glow from the msg.sender
        gusd.approve(address(this), 2**256 - 1); // msg.sender

        // Step 0: Transfer GUSD to the Glow contract
        gusd.transfer(address(this), amt_);

        // Step 2: Execute Sell Gem on the GUSD PSM
        //uint256 balance = gusd.balanceOf(address(this));
        gusdPsm.sellGem(address(this), amt_);


        // SellGem
    }
}
