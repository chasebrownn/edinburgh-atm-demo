// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {EdiCoin} from "../src/EdiCoin.sol";
import {ATM} from "../src/ATM.sol";

/// @notice Deploys EdiCoin + the ATM, then loads the ATM with 1000 tokens.
///
/// Run with:
///   forge script script/Deploy.s.sol --rpc-url sepolia --account demo --broadcast --verify
contract Deploy is Script {
    function run() external {
        vm.startBroadcast();

        EdiCoin token = new EdiCoin();
        ATM atm = new ATM(token);
        token.mint(address(atm), 1000e18);

        vm.stopBroadcast();

        console.log("EdiCoin deployed at:", address(token));
        console.log("ATM deployed at:    ", address(atm));
        console.log("ATM loaded with 1000 EDI");
    }
}
