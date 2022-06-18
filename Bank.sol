// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

contract SimpleBank{

    address owner;
    mapping(address => uint) private balances;
    event LogDeposit(address accountAaddress, uint amount);

    constructor(){
        owner = msg.sender;
    }

    function deposit() public payable returns(uint){
        require((balances[msg.sender] + msg.value) >= balances[msg.sender]);
        balances[msg.sender] += msg.value;
        emit LogDeposit(msg.sender, msg.value);
        return balances[msg.sender];
    }   

    function withdraw(uint withdrawAmount) public payable returns(uint){
        require(withdrawAmount <= balances[msg.sender], "Insufficient funds");
        balances[msg.sender] -= withdrawAmount;
        payable(msg.sender).transfer(withdrawAmount);
        return balances[msg.sender];
    }

    function balance() public view returns(uint){
        return balances[msg.sender];
    }
    
}