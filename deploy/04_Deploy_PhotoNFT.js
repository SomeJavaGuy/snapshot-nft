module.exports = async ({
    getNamedAccounts,
    deployments,
    getChainId,
    getUnnamedAccounts,
  }) => {
    const {deploy} = deployments;
    const {deployer} = await getNamedAccounts()
    
    console.log("----------------------------------------------------")
    console.log('Deploying PhotoNFT');
      const photoFactory = await deploy('PhotoNFT', {
      from: deployer,
      gasLimit: 4000000,
    });

    console.log("PhotoNFT deployed to: ", photoFactory.address)

  };