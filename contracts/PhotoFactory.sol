//Contract based on https://docs.openzeppelin.com/contracts/3.x/erc721
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "./PhotoNFT.sol";
import "hardhat/console.sol";
import "@chainlink/contracts/src/v0.6/VRFConsumerBase.sol";
//import "@chainlink/contracts/src/v0.6/VRFConsumerBase.sol";

contract PhotoFactory is VRFConsumerBase{

	string public name = "Photo Token Farm";
	PhotoNFT public photoNFT;
	address public owner;
	uint256 public baseAmount = 10 wei;
	uint256 public totalBalance;
	address[] public stakers;

	// maps from address => value of tokens
	mapping(address => bool) public hasStaked;
	mapping(address => bool) public isStaking;

	bytes32 internal keyHash;
    uint256 internal fee;
    uint256 public randomResult;
    
    /**
     * Constructor inherits VRFConsumerBase
     * 
     * Network: Kovan
     * Chainlink VRF Coordinator address: 0xdD3782915140c8f3b190B5D67eAc6dc5760C46E9
     * LINK token address:                0xa36085F69e2889c224210F603D836748e7dC0088
     * Key Hash: 0x6c3699283bda56ad74f6b855546325b68d482e983852a7a82979cc4807b641f4
     */
    constructor(address _vrfCoordinator,
                address _link,
                bytes32 _keyHash,
                uint _fee) 
        VRFConsumerBase(
            _vrfCoordinator, // VRF Coordinator
            _link  // LINK Token
        ) public
    {
        keyHash = _keyHash;
        fee = _fee;
    }

     /** 
     * Requests randomness from a user-provided seed
     */
    function getRandomNumber(uint256 userProvidedSeed) public returns (bytes32 requestId) {
        require(LINK.balanceOf(address(this)) > fee, "Not enough LINK - fill contract with faucet");
        return requestRandomness(keyHash, fee, userProvidedSeed);
    }

    /**
     * Callback function used by VRF Coordinator
     */
    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        randomResult = randomness;
    }
    
    /**
     * Withdraw LINK from this contract
     * 
     * DO NOT USE THIS IN PRODUCTION AS IT CAN BE CALLED BY ANY ADDRESS.
     * THIS IS PURELY FOR EXAMPLE PURPOSES.
     */
    function withdrawLink() external {
        require(LINK.transfer(msg.sender, LINK.balanceOf(address(this))), "Unable to transfer");
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