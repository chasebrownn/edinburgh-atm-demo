// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

/// @title ATM
/// @author @chasebrownn
/// @notice A cash machine that dispenses exactly 1 token per withdrawal.
///         Anyone can press the button, as many times as they like,
///         until the machine runs out of cash.
contract ATM {
    /// @notice The token this ATM dispenses.
    IERC20 public immutable token;

    /// @notice One whole token (the token has 18 decimals).
    uint256 public constant WITHDRAW_AMOUNT = 1e18;

    event Withdrawal(address indexed who, uint256 amount);

    constructor(IERC20 _token) {
        token = _token;
    }

    /// @notice Take 1 token out of the machine.
    function withdraw() external {
        require(token.balanceOf(address(this)) >= WITHDRAW_AMOUNT, "ATM: out of cash");
        require(token.transfer(msg.sender, WITHDRAW_AMOUNT), "ATM: transfer failed");
        emit Withdrawal(msg.sender, WITHDRAW_AMOUNT);
    }

    /// @notice How much cash is left in the machine?
    function cashLeft() external view returns (uint256) {
        return token.balanceOf(address(this));
    }
}
