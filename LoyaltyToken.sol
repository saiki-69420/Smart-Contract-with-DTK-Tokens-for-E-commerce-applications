// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract LoyaltyToken is ERC20 {
    address public immutable owner;

    constructor() ERC20("DiscountToken", "DTK") {
        owner = msg.sender; // The account that deploys this contract is set as the owner
        require(owner == address(0x522a1f5BA28c5AD192849f337896393379B54a6c), "You are not authorized to deploy this contract");
        _mint(owner, 500 * 10 ** uint256(decimals()));
    }
}