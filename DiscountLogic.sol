// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


import "./LoyaltyToken.sol";
import "./UnspentLoyaltyToken.sol";

contract DiscountLogic {
    address public owner;
    LoyaltyToken public discountToken;
    UnspentLoyaltyToken public unspentTokens;

    struct Customer {
        string name;
        uint256 dtksBalance;
        bool isRegistered;
    }

    mapping(address => Customer) public customers;

    event Purchase(address indexed customer, uint256 amount, uint256 tokensTransferred);
    event DiscountUtilized(address indexed customer,  uint256 discount);

    constructor(address _discountTokenAddress, address _unspentTokensAddress) {
        owner = msg.sender;
        discountToken = LoyaltyToken(_discountTokenAddress);
        unspentTokens = UnspentLoyaltyToken(_unspentTokensAddress);
    }

    function registerCustomer(address _customer, string memory _name) external {
        // require(msg.sender == owner, "Only the owner can register customers");
        require(!customers[_customer].isRegistered, "Customer already registered");
        customers[_customer].isRegistered = true;
        customers[_customer].name = _name;
    }

    function utilizeDiscount(uint256 _discount,address _buyeraddress) external {
        Customer storage customer = customers[_buyeraddress];
        require(_discount <= 50,"Invalid Discount");
        require(customer.isRegistered, "Customer is not registered");

        uint256 tokensToUtilize = _discount*10**discountToken.decimals(); // Assuming 1 token = 1 unit of purchase amount
        require(discountToken.balanceOf(_buyeraddress) >= tokensToUtilize, "Insufficient DTokens");
        unspentTokens.depositTokens(_buyeraddress, tokensToUtilize);
        // Calculate the discount percentage based on tokens
        // uint256 discount = tokensToUtilize; // Assuming 1 token = 1% discount
        // Implement your logic to apply the discount, deduct from total purchase amount, etc.

        //customer.dtksBalance -= tokensToUtilize;
        emit DiscountUtilized(msg.sender, _discount);
    }

    function purchaseItem(uint256 _amount,uint256 _discount) external {

        address _buyeraddress = msg.sender;
        require(customers[_buyeraddress].isRegistered, "Customer is not registered");
        this.utilizeDiscount(_discount,_buyeraddress);
        uint256 finalAmount = (_amount*(100-_discount))/100;

        // Transfer DTKs from owner to customer based on the purchase amount
        uint256 tokensToSend = (finalAmount/10) * 10 ** discountToken.decimals(); // Assuming 1 token = 1 unit of purchase amount
        
        discountToken.transferFrom(owner, _buyeraddress, tokensToSend);

        emit Purchase(_buyeraddress, _amount, tokensToSend);
    }

    
}