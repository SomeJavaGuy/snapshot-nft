//Contract based on https://docs.openzeppelin.com/contracts/3.x/erc721
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "./PhotoNFT.sol";
import "hardhat/console.sol";
import "@chainlink/contracts/src/v0.6/VRFConsumerBase.sol";
//import "@chainlink/contracts/src/v0.6/VRFConsumerBase.sol";

contract PhotoFactory {

	string public name = "Photo Token Farm";
	PhotoNFT public photoNFT;
	address public owner;
	uint256 public baseAmount = 10 wei;
	uint256 public totalBalance;
	address[] public stakers;

	// maps from address => value of tokens
	mapping(address => bool) public hasStaked;
	mapping(address => bool) public isStaking;

	constructor(PhotoNFT _photoNFT) public {
		photoNFT = _photoNFT;
	}

	function stakeETH() public payable {

		// Checks for payment.
		require(msg.value >= baseAmount, "amount must equal fee");

		require(!hasStaked[msg.sender], "already staking");

		//Add user to stakers array iff they haven't staked already
		stakers.push(msg.sender);

		totalBalance += msg.value;

		hasStaked[msg.sender] = true; 
		isStaking[msg.sender] = true;
	}

	//pseudorandom number
	uint nonce = 0;
	function psuedoRandNum() private returns (uint) {
		uint randomnumber = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, nonce))) % stakers.length;
		randomnumber = randomnumber;
		nonce++;        
		return randomnumber;
	}


}