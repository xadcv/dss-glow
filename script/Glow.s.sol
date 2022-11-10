// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../src/Glow.sol";
import "../lib/forge-std/src/Script.sol";

contract DeployScript is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        Glow glow = new Glow(vm.envAddress("CHAINLOG"));

        vm.stopBroadcast();
    }
}
