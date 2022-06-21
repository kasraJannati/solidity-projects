// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

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

    constructor(){

    }

    function createMarketItem(){

    }

    function createMarketSale(){

    }

    function fetchMarketItems() {

    }

    function fetchMyNFTs() {
        
    }

}