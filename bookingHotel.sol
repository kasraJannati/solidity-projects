// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

contract HotelRoom{

    bool public status;
    address owner;
    
    event Occupy(address _occupant, uint _value);

    constructor() {
        owner = msg.sender;
        status = false;
    }

    modifier checkBookingStatus{
        require(status == false, "Currently occupied!");
        _;
    }

    modifier checkCosts(uint _amount){
        require(msg.value >= _amount, "Not enough ether provided.");
        _;
    }

    function book() public payable checkBookingStatus checkCosts(2 ether){
        status = true;

        (bool success, bytes memory data) = owner.call{value: msg.value}("");
        require(success, "Call failed!");

        emit Occupy(msg.sender, msg.value);
    }
    
}