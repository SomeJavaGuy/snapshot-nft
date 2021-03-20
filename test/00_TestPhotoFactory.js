
const { expect } = require("chai");

describe("PhotoNFT contract", function () {

  let PhotoFactory;
  let photoNFT;
  let owner;
  let addr1;
  let addr2;
  let addrs;

  beforeEach(async function () {
    // Get the ContractFactory and Signers here.
  });

  // You can nest describe calls to create subsections.
  describe("Deployment", function () {
    // `it` is another Mocha function. This is the one you use to define your
    // tests. It receives the test name, and a callback function.

      it("Should assign the total supply of photos to the owner", async function () {
      
      //deploy token
      PhotoFactory = await ethers.getContractFactory("PhotoFactory");
      [owner, addr1, addr2, ...addrs] = await ethers.getSigners();
      photoFactory = await PhotoFactory.deploy();
      await photoFactory.deployed();

      PhotoNFT = await ethers.getContractFactory("PhotoNFT");
      photoNFT = await PhotoFactory.deploy();
      await photoNFT.deployed();

      const ownerBalance = await photoNFT.balanceOf(owner.address);
      expect(await photoNFT.totalSupply()).to.equal(ownerBalance);
    });
  });

  describe("Minting", function () {
    // `it` is another Mocha function. This is the one you use to define your
    // tests. It receives the test name, and a callback function.
    
    it("Should assign a new photo to the owner", async function () {
      await photoNFT.mint("URL1");
      expect(await photoNFT.totalSupply()).to.equal(1);
      expect(await photoNFT.ownerOf(0)).to.equal(owner.address);
    });

    it("Should assign a second photo to the owner", async function () {
      await photoNFT.mint("URL2");
      expect(await photoNFT.totalSupply()).to.equal(2);
      expect(await photoNFT.ownerOf(1)).to.equal(owner.address);
    });

    
    it("Should transfer an NFT", async function () {
      await photoNFT.transferFrom(owner.address, addr1.address, 1)
      expect(await photoNFT.totalSupply()).to.equal(2);
      expect(await photoNFT.ownerOf(1)).to.equal(addr1.address);
      //console.log("approved: ", await photoNFT.ownerOf(1));
      // await photoNFT.transferFrom("URL1");
      // expect(await photoNFT.ownerOf('1')).to.equal(owner.address);
    });

  });
});

    // it("Should assign the photo with the correct id", async function () {
    //   expect(await photoNFT.ownerOf(1)).to.equal(owner.address);
    // })

