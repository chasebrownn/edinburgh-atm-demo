// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {EdiCoin} from "../src/EdiCoin.sol";
import {ATM} from "../src/ATM.sol";

contract ATMTest is Test {
    EdiCoin token;
    ATM atm;

    address alice = makeAddr("alice");

    function setUp() public {
        token = new EdiCoin();
        atm = new ATM(token);

        // Load the ATM with 100 tokens of cash.
        token.mint(address(atm), 100e18);
    }

    function test_Withdraw() public {

        uint256 amount = 1e18;

        assertEq(token.balanceOf(address(atm)), 100e18);
        assertEq(token.balanceOf(address(alice)), 0);

        vm.prank(alice);
        atm.withdraw();

        assertEq(token.balanceOf(address(atm)), 100e18 - amount);
        assertEq(token.balanceOf(address(alice)), amount);
    }
}
