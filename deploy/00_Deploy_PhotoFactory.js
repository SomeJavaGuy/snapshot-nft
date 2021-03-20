module.exports = async ({
    getNamedAccounts,
    deployments,
    getChainId,
    getUnnamedAccounts,
  }) => {
    const {deploy} = deployments;
    const {deployer} = await getNamedAccounts()
    
    //LINK Token address set to Kovan address. Can get other values at https://docs.chain.link/docs/link-token-contracts
    const LINK_TOKEN_ADDR="0xa36085F69e2889c224210F603D836748e7dC0088"
    const VRF_COORDINATOR="0xdD3782915140c8f3b190B5D67eAc6dc5760C46E9"
    const VRF_FEE="100000000000000000"
    const VRF_KEYHASH="0x6c3699283bda56ad74f6b855546325b68d482e983852a7a82979cc4807b641f4"
    //const PHOTO_NFT_ADDR = "0x0000000000000000000000000000000000000000"

    console.log("----------------------------------------------------")
    console.log('Deploying PhotoFactory');
      const photoFactory = await deploy('PhotoFactory', {
      from: deployer,
      gasLimit: 4000000,
      args: [VRF_COORDINATOR,LINK_TOKEN_ADDR,VRF_KEYHASH,VRF_FEE],
    });

    console.log("PhotoFactory deployed to: ", photoFactory.address)

  };