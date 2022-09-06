// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

contract Lottery is VRFConsumerBaseV2{

    VRFCoordinatorV2Interface COORDINATOR;
    uint64 s_subscriptionId; // Your subscription ID.
    // Goerli coordinator. For other networks,
    // see https://docs.chain.link/docs/vrf-contracts/#configurations
    address vrfCoordinator = 0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D; //The address of the Chainlink VRF Coordinator contract.
    // The gas lane to use, which specifies the maximum gas price to bump to.
    // For a list of available gas lanes on each network,
    // see https://docs.chain.link/docs/vrf-contracts/#configurations
    bytes32 keyHash = 0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15;  //The gas lane key hash value, which is the maximum gas price you are willing to pay for a request in wei. It functions as an ID of the off-chain VRF job that runs in response to requests.
    // Depends on the number of requested values that you want sent to the
    // fulfillRandomWords() function. Storing each word costs about 20,000 gas,
    // so 100,000 is a safe default for this example contract. Test and adjust
    // this limit based on the network that you select, the size of the request,
    // and the processing of the callback request in the fulfillRandomWords()
    // function.
    uint32 callbackGasLimit = 100000; //The limit for how much gas to use for the callback request to your contract's fulfillRandomWords() function. It must be less than the maxGasLimit limit on the coordinator contract. In this example, the fulfillRandomWords() function stores two random values, which cost about 20,000 gas each, so a limit of 100,000 gas is sufficient. Adjust this value for larger requests depending on how your fulfillRandomWords() function processes and stores the received random values. If your callbackGasLimit is not sufficient, the callback will fail and your subscription is still charged for the work done to generate your requested random values.
    uint16 requestConfirmations = 3; //The default is 3, but you can set this higher. How many confirmations the Chainlink node should wait before responding. The longer the node waits, the more secure the random value is. It must be greater than the minimumRequestBlockConfirmations limit on the coordinator contract.
    uint32 numWords =  1; //How many random values to request. If you can use several random values in a single callback, you can reduce the amount of gas that you spend per random value. The total cost of the callback request depends on how your fulfillRandomWords() function processes and stores the received random values, so adjust your callbackGasLimit accordingly.
    uint public s_randomRange;
    uint256 public s_requestId;
    // address s_owner;

    address public mainWallet = 0xec001D225966Af2b4F0E7d5b79aa9455B2a1149a; //account 222
    uint public costTicket = 0.0000000000000001 ether; //100 Wei
    address private owner;
    event LogBuyer(address accountBuyer);

    mapping(address => uint) private balances;
    event LogDeposit(address accountAaddress, uint amount);

    constructor(uint64 subscriptionId) VRFConsumerBaseV2(vrfCoordinator){
        owner = msg.sender;

        COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);
        // s_owner = msg.sender;
        s_subscriptionId = subscriptionId; //The subscription ID that this contract uses for funding requests.
    }

    function deposit() public payable returns(uint){
        require((balances[msg.sender] + msg.value) >= balances[msg.sender]);
        balances[msg.sender] += msg.value;
        emit LogDeposit(msg.sender, msg.value);
        return balances[msg.sender];
    }  
    function balance() public view returns(uint256){
        return owner.balance;
    }  

    function buyTicket() public payable returns(address){
        require(costTicket <= balances[msg.sender], "Insufficient funds");
        balances[msg.sender] -= costTicket;
        payable(msg.sender).transfer(costTicket);
        emit LogBuyer(msg.sender);
        return msg.sender;
    }


    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    // Assumes the subscription is funded sufficiently.
    // Will revert if subscription is not set and funded.
    //  Takes your specified parameters and submits the request to the VRF coordinator contract.
    function requestRandomWords() external onlyOwner {   
        s_requestId = COORDINATOR.requestRandomWords(
            keyHash,
            s_subscriptionId,
            requestConfirmations,
            callbackGasLimit,
            numWords
        );
    }
    //Receives random values and stores them with your contract.
    function fulfillRandomWords(uint256, uint256[] memory randomWords) internal override {
        s_randomRange = (randomWords[0] % 50) + 1;
    }


}