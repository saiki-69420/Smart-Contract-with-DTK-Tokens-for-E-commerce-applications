// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./LoyaltyToken.sol";

contract UnspentLoyaltyToken {
    LoyaltyToken public discountTokenContract; // Define the DiscountToken type

    mapping(address => uint256) public unspentTokenBalance;

    constructor(address _discountTokenAddress) {
        discountTokenContract = LoyaltyToken(_discountTokenAddress);
    }

    function depositTokens(address _sender, uint256 _amount) external {
        discountTokenContract.transferFrom(_sender, address(this), _amount); // Using ERC20 transferFrom
        unspentTokenBalance[_sender] += _amount;
    }
}