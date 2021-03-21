const { expect } = require("chai");
const { web3 } = require("hardhat");

const hre = require("hardhat");

describe("PhotoFactory", async function() {

  //LINK Token address set to Kovan address
  const LINK_TOKEN_ADDR="0xa36085F69e2889c224210F603D836748e7dC0088";
  //VRF Details set for Kovan environment
  const VRF_COORDINATOR="0xdD3782915140c8f3b190B5D67eAc6dc5760C46E9"
  const VRF_FEE="100000000000000000"
  const VRF_KEYHASH="0x6c3699283bda56ad74f6b855546325b68d482e983852a7a82979cc4807b641f4"

  let PhotoFactory;
  let photoFactory;
  let owner;
  let addr1;
  let addr2;
  let addrs;

  it("It should deploy", async function() {
    //deploy the contract
    this.timeout(0)
    PhotoFactory = await ethers.getContractFactory("PhotoFactory");
    photoFactory = await PhotoFactory.deploy(VRF_COORDINATOR,LINK_TOKEN_ADDR,VRF_KEYHASH,VRF_FEE);
    await photoFactory.deployed();
    [owner, addr1, addr2, ...addrs] = await ethers.getSigners();
  });

  it("It should successfully stake eth", async function() {
    //Before we can do a VRF request, we need to fund it with LINK
    await hre.run("fund-link",{contract: photoFactory.address})

    //Now that contract is funded, we can call the function to stake eth
    await hre.run("stake-eth",{contract: photoFactory.address, amount: web3.utils.toWei("0.001")})
    let result = await photoFactory.isStaking(owner.address)    
    expect(result).to.be.true
  });

  it("It should successfully mint a photo", async function() {
    this.timeout(0)
    //Now that the contract deployer is the "currentMinter" we can mint an NFT to kick off the chain
    await hre.run("mint-photo",{contract: photoFactory.address, url: "https://www.myfirstNFT.xyz", title: "I hope this works"})
    let result = await photoFactory.ownerOf(0)    
    expect(result).to.equal(owner.address)
  });

  it("It should successfully unstake eth", async function() {
    // call the function to unstake eth
    await hre.run("unstake-eth",{contract: photoFactory.address, from: addr1})
    let result = await photoFactory.isStaking()
    expect(result).to.be.false
  });
});
