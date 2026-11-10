// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

/// @title EdiCoin
/// @author @chasebrownn
/// @notice A simple token for the University of Edinburgh demo.
///         Anyone can mint and anyone can burn their own tokens —
///         this is a toy for learning, not real money!
contract EdiCoin is ERC20 {
    constructor() ERC20("EdiCoin", "EDI") {}

    /// @notice Create `amount` new tokens and give them to `to`.
    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }

    /// @notice Destroy `amount` of your own tokens.
    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }
}
