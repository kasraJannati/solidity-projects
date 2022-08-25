// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

contract Bet{

    address owner;
    mapping(address => uint) private balances;
    event LogDeposit(address accountAaddress, uint amount);


    address mainWallet = 0x03C6FcED478cBbC9a4FAB34eF9f40767739D1Ff7;
    uint costTicket = 1 ether;

    constructor(){
        owner = msg.sender;
    }

    function deposit() public payable returns(uint){
        require((balances[msg.sender] + msg.value) >= balances[msg.sender]);
        balances[msg.sender] += msg.value;
        emit LogDeposit(msg.sender, msg.value);
        return balances[msg.sender];
    }   

    function buyTicket() public payable returns(uint){
        require(costTicket <= balances[msg.sender], "Insufficient funds");
        balances[msg.sender] -= costTicket;
        payable(mainWallet).transfer(costTicket);
        return balances[msg.sender];
    }

    function balance() public view returns(uint){
        return balances[msg.sender];
    }

}