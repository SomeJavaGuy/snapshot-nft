//Contract based on https://docs.openzeppelin.com/contracts/3.x/erc721
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.6;

import "./PhotoNFT.sol";
import "hardhat/console.sol";
import "@chainlink/contracts/src/v0.6/VRFConsumerBase.sol";
//import "@chainlink/contracts/src/v0.6/VRFConsumerBase.sol";

contract PhotoFactory is VRFConsumerBase, PhotoNFT {

    event NewWinner(address winner);
    event insufficentFunds(bool staker);
    event photoMinted(bool isStaking, address currentMinter, address sender);
    event ethWasStaked(address staker, uint256 amount);

	//string public name = "Photo Token Farm";
	PhotoNFT public photoNFT;
	address public owner;
	uint256 public baseAmount = 1000000000000000 wei;
	uint256 public totalBalance;
	address[] public stakers;

	address public currentMinter;


	// maps from address => value of tokens
	mapping(address => bool) public isStaking;
	mapping(uint256 => bool) public isRequestId;
    mapping(address => uint256) public addressToStakerId;

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
		currentMinter = msg.sender;
    }

    /*
    1. Make sure that the function caller is the minter
    2. Mint the NFT with the data provided by the user
    3. Calls get random number (using the title as the seed) and mods by the total number of people in the pool
	4. Assign the new minter to the address of the random number
	5. V2 automatically put it up for auction on opensea
    */
    function photoMint(string memory _URL, string memory _title) public {
    	emit photoMinted(isStaking[msg.sender], currentMinter, msg.sender);
    	require(msg.sender == currentMinter, "CANNOT MINT");
		mint(_URL, _title);
        // call get random number
        require(LINK.balanceOf(address(this)) > fee, "Not enough LINK - fill contract with faucet");
        requestRandomness(keyHash, fee, 42);
    }

    function getCurrentMinter() public view returns(address) {
    	return currentMinter;
    }

    //V2: TODO: automatically put a token up for aution on opensea
    // function auction(address _tokenAddress) {

    // }
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
        uint256 winner = randomResult % stakers.length - 1;
        currentMinter = stakers[winner];
        emit NewWinner(currentMinter);
    }

    //ustakes ETH from the message sender
    function unstakeETH() public {
        require(isStaking[msg.sender]);
        // Remember to zero the pending refund before
        // sending to prevent re-entrancy attacks
        isStaking[msg.sender] = false;

        // Find where unstaker is in staker array
        uint256 stakerId = addressToStakerId[msg.sender];

        // remove them from the mapping, and the stakers array
        delete addressToStakerId[msg.sender];
        delete stakers[stakerId];

        // move the last element in the list to the gap, and decrement the length
        address lastStaker = stakers[stakers.length - 1];
        stakers[stakerId] = lastStaker;
        stakers.pop();
        addressToStakerId[lastStaker] = stakerId;

        msg.sender.transfer(baseAmount);
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
		require(msg.value == baseAmount, "amount must equal fee");

		require(!isStaking[msg.sender], "already staking");

        emit ethWasStaked(msg.sender, msg.value);

		//Add user to stakers array iff they haven't staked already
		stakers.push(msg.sender);
        addressToStakerId[msg.sender] = stakers.length - 1;

		totalBalance += msg.value;
 
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