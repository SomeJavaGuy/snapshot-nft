
// const { expect } = require("chai");

// describe("PhotoNFT contract", function () {

//   let PhotoFactory;
//   let photoNFT;
//   let owner;
//   let addr1;
//   let addr2;
//   let addrs;

//   beforeEach(async function () {
//     // Get the ContractFactory and Signers here.
//   });

//   // You can nest describe calls to create subsections.
//   describe("Deployment", function () {
//     // `it` is another Mocha function. This is the one you use to define your
//     // tests. It receives the test name, and a callback function.

//       it("Should assign the total supply of photos to the owner", async function () {
      
//       //deploy token
//       PhotoFactory = await ethers.getContractFactory("PhotoFactory");
//       [owner, addr1, addr2, ...addrs] = await ethers.getSigners();
//       photoFactory = await PhotoFactory.deploy();
//       await photoFactory.deployed();

//       PhotoNFT = await ethers.getContractFactory("PhotoNFT");
//       photoNFT = await PhotoFactory.deploy();
//       await photoNFT.deployed();

//       const ownerBalance = await photoNFT.balanceOf(owner.address);
//       expect(await photoNFT.totalSupply()).to.equal(ownerBalance);
//     });
//   });

//   describe("Minting", function () {
//     // `it` is another Mocha function. This is the one you use to define your
//     // tests. It receives the test name, and a callback function.
    
//     it("Should assign a new photo to the owner", async function () {
//       await photoFactory.mint("URL1");
//       expect(await photoNFT.totalSupply()).to.equal(1);
//       expect(await photoNFT.ownerOf(0)).to.equal(owner.address);
//     });

//     it("Should assign a second photo to the owner", async function () {
//       await photoNFT.mint("URL2");
//       expect(await photoNFT.totalSupply()).to.equal(2);
//       expect(await photoNFT.ownerOf(1)).to.equal(owner.address);
//     });

    
//     it("Should transfer an NFT", async function () {
//       await photoNFT.transferFrom(owner.address, addr1.address, 1)
//       expect(await photoNFT.totalSupply()).to.equal(2);
//       expect(await photoNFT.ownerOf(1)).to.equal(addr1.address);
//       //console.log("approved: ", await photoNFT.ownerOf(1));
//       // await photoNFT.transferFrom("URL1");
//       // expect(await photoNFT.ownerOf('1')).to.equal(owner.address);
//     });

//   });
// });

//     // it("Should assign the photo with the correct id", async function () {
//     //   expect(await photoNFT.ownerOf(1)).to.equal(owner.address);
//     // })



const { expect } = require("chai");

const hre = require("hardhat");

describe("PhotoFactory", async function() {

    //LINK Token address set to Kovan address. Can get other values at https://docs.chain.link/docs/link-token-contracts
    const LINK_TOKEN_ADDR="0xa36085F69e2889c224210F603D836748e7dC0088";
    //VRF Details set for Kovan environment, can get other values at https://docs.chain.link/docs/vrf-contracts#config
    const VRF_COORDINATOR="0xdD3782915140c8f3b190B5D67eAc6dc5760C46E9"
    const VRF_FEE="100000000000000000"
    const VRF_KEYHASH="0x6c3699283bda56ad74f6b855546325b68d482e983852a7a82979cc4807b641f4"

    //deploy the contract
    this.timeout(0)
    const PhotoFactory = await ethers.getContractFactory("PhotoFactory");
    const photoFactory = await PhotoFactory.deploy(VRF_COORDINATOR,LINK_TOKEN_ADDR,VRF_KEYHASH,VRF_FEE);
    await photoFactory.deployed();
    [owner, addr1, addr2, ...addrs] = await ethers.getSigners();

  it("It should successfully stake eth", async function() {
    //Before we can do an API request, we need to fund it with LINK
    await hre.run("fund-link",{contract: photoFactory.address})

    //Now that contract is funded, we can call the function to stake eth
    await hre.run("stake-eth",{contract: photoFactory.address})
    let result = await photoFactory.isStaking(owner.address)    
    expect(result == true)

  });
  it("It should successfully mint a photo", async function() {
    //Now that we are a staker, we can 
    await hre.run("mint-photo",{contract: photoFactory.address, url: "http://www.myfirstNFT.xyz", title: "I hope this works"})
    let result = await photoFactory.ownerOf(0)    
    expect(result == owner.address)
  });
  it("It should successfully unstake eth", async function() {
    // call the function to unstake eth
    await hre.run("unstake-eth",{contract: photoFactory.address, from: addr1})
    let result = await photoFactory.isStaking()
    expect(result == false)

  });
});
