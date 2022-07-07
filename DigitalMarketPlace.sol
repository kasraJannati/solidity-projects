// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

/* 
ERC-721 is a token standard on Ethereum for non-fungible tokens (NFTs). 
Fungible means interchangeable and replaceable; 
Bitcoin is fungible because any Bitcoin can replace any other Bitcoin. Each NFT, on the other hand, is completely unique.
One NFT cannot replace another. 
*/
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";   
import "@openzeppelin/contracts/utils/Counters.sol"; 
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import "hardhat/console.sol";  // When running your contracts and tests on Hardhat Network you can print logging messages and contract variables calling console.log() from your Solidity code.
import "@openzeppelin/contracts/security/ReentrancyGuard.sol"; //Contract module that helps prevent reentrant calls to a function.

contract NFT is ERC721URIStorage{ 

    constructor(){

    }

    function createToken(){

    }

}

contract NFTMarket is ReentrancyGuard{

    _itemsIds; // unique id for every market place item
    _itemsSold; // how many items sold

    struct MakarketItem {
        uint itemId;   // unique identifier
        address nftContract; // contacrt address - digital asset
        uint256 tokenId; //  token Id for asset
        address payable seller; // address of seller
        address payable owner; // address of owner 
        uint256 price; // price of nft
    }

    mapping(uint256 => MakarketItem) private idToMarketItem;

    event MarketCreated(
        uint indexed itemId,
        address indexed nftContract,
        uint256 indexed tokenId,
        address seller,
        address owner,
        uint256 price
        )

    constructor(){

    }

    //createMarketItem function allows us to put items
    function createMarketItem(address nftContract, uint256 tokenId, uint256 price) public payable nonReentrant{
        require(price > 0, "price must be at least 1 wei");

        // define local variables
        _itemsIds.increment();
        uint256 itemId = _itemsIds.current()
        

        idToMarketItem[itemId] = MakarketItem(
            itemId,
            nftContract,
            tokenId,
            payable(msg.sender),
            payable(address(0)),
            price
        )

        IERC721(nftContract).transferFrom(msg.sender, address(this), tokenId);  // From openZeppelin => transferFrom(address from, address to, uint256 tokenId)

        emit MarketCreated(
            itemId,
            nftContract,
            tokens,
            msg.sender,
            address(0),
            price
        )

    }

    function createMarketSale(){

    }

    function fetchMarketItems() {

    }

    function fetchMyNFTs() {
        
    }

}