// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

/* 
ERC-721 is a token standard on Ethereum for non-fungible tokens (NFTs). 
Fungible means interchangeable and replaceable; 
Bitcoin is fungible because any Bitcoin can replace any other Bitcoin. Each NFT, on the other hand, is completely unique.
One NFT cannot replace another. 
*/
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";   
import "@openzeppelin/contracts/utils/Counters.sol"; // Counters: a simple way to get a counter that can only be incremented or decremented. Very useful for ID generation, counting contract activity, among others
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import "hardhat/console.sol";  // When running your contracts and tests on Hardhat Network you can print logging messages and contract variables calling console.log() from your Solidity code.
import "@openzeppelin/contracts/security/ReentrancyGuard.sol"; //Contract module that helps prevent reentrant calls to a function.

contract NFT is ERC721URIStorage{ 

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    address contractAddress;

    constructor(address marketPlaceAddress) ERC721("Kasra's Digital Marketplace","KDM"){
        contractAddress = marketPlaceAddress;
    }

    function createToken(string memory tokenURI) public returns(uint){
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);
        setApprovalForAll(contractAddress, true);
        return newItemId;
    }

}

contract NFTMarket is ReentrancyGuard{

    using Counters for Counters.Counter;
    Counters.Counter private _itemIds; // unique id for every market place item
    Counters.Counter private _itemsSold; // how many items sold
    address payable owner; // to get profit 
    uint listingPrice = 10 ether; // to get profit 

    struct MarketItem {
        uint itemId;   // unique identifier
        address nftContract; // contacrt address - digital asset
        uint256 tokenId; //  token Id for asset
        address payable seller; // address of seller
        address payable owner; // address of owner 
        uint256 price; // price of nft
    }

    mapping(uint256 => MarketItem) private idToMarketItem;

    event MarketCreated(
        uint indexed itemId,
        address indexed nftContract,
        uint256 indexed tokenId,
        address seller,
        address owner,
        uint256 price
    );

    constructor(){
        owner = payable(msg.sender); // to get profit 
    }

    //createMarketItem function allows us to put items
    function createMarketItem(address nftContract, uint256 tokenId, uint256 price) public payable nonReentrant{
        require(price > 0, "price must be at least 1 wei");
        require(msg.value == listingPrice, "Price must be equal to listing price"); // to get profit 
        // define local variables
        _itemIds.increment();
        uint256 itemId = _itemIds.current();
        idToMarketItem[itemId] = MarketItem(
            itemId,
            nftContract,
            tokenId,
            payable(msg.sender),
            payable(address(0)),
            price
        );
        IERC721(nftContract).transferFrom(msg.sender, address(this), tokenId);  // From openZeppelin => transferFrom(address from, address to, uint256 tokenId)
        emit MarketCreated(
            itemId,
            nftContract,
            tokenId,
            msg.sender,
            address(0),
            price
        );
    }

    /** takes two arguments **/
    function createMarketSale(address nftContract, uint256 itemId) public payable nonReentrant{
        uint price = idToMarketItem[itemId].price;
        uint tokenId = idToMarketItem[itemId].tokenId;
        require(msg.value == price,"Please submit the asking price in order to complete the purchase");
        idToMarketItem[itemId].seller.transfer(msg.value);
        IERC721(nftContract).transferFrom(address(this), msg.sender, tokenId);  // From openZeppelin => transferFrom(address from, address to, uint256 tokenId)
        idToMarketItem[itemId].owner = payable(msg.sender);
        _itemsSold.increment();
        payable(owner).transfer(listingPrice);
    }

    /* fetch items that are avaiable to sell */
    function fetchMarketItems() public view returns (MarketItem[] memory){
        uint itemCount = _itemIds.current(); // total items that created so far
        uint unsoldItemCount = itemCount - _itemsSold.current(); //  items that still not yet sold
        uint currentIndex = 0;
        
        MarketItem[] memory items = new MarketItem[](unsoldItemCount);
        for (uint i=0; i < itemCount; i++) {
            if(idToMarketItem[i + 1].owner == address(0)){
                uint currentId = idToMarketItem[i + 1].itemId;
                MarketItem storage currentItem = idToMarketItem[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }   

    /* fetch items that we have purchase ourselves */
    function fetchMyNFTs()  public view returns (MarketItem[] memory){
        uint totalItemCount = _itemIds.current(); // total items that created so far
        uint itemCount = 0; //  items that still not yet sold
        uint currentIndex = 0;
        for (uint i=0; i < totalItemCount; i++) {
            if(idToMarketItem[i + 1].owner == msg.sender){
                itemCount += 1;
            }
        }
        MarketItem[] memory items = new MarketItem[](itemCount);
        for (uint i=0; i < totalItemCount; i++) {
            if(idToMarketItem[i + 1].owner == msg.sender){
                uint currentId = idToMarketItem[i + 1].itemId;
                MarketItem storage currentItem = idToMarketItem[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }

}