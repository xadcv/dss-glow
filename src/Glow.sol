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

    address gusdAddress;
    address daiAddress;

    constructor(address chainlog_) {
        changelog = ChainLogLike(chainlog_);
        gusdAddress = changelog.getAddress("GUSD");
        daiAddress = changelog.getAddress("MCD_DAI");
        gusd = Gusd(gusdAddress);
        dai = Dai(daiAddress);
    }

    function DssGlow(address usr, uint256 amt) public {}
}
