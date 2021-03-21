### hackathon project
playing around with some non-fungies

### details

What's more decentralized than an NFT collection for which each minter is selected at random?

 This is a lottery game where 1 participant is randomly selected each day to take a photograph of their life taken on that day, which is minted as an NFT and added to the project's collection. 

### instructions

Clone this repo, then run
```
yarn && yarn test
```
and see what happens!

Or, run the following to deploy and interact directly with the contract
```
npx hardhat deploy
npx hardhat fund-link --contract {contract address from deployment}
npx hardhat stake-eth --contract {contract address from deployment}
npx hardhat mint-photo --contract {contract address from deployment} --url {URL of your photo} --title {name your photo!}
npx hardhat unstake-eth
```
We are working on integrating these actions into a front-end.

You may also need to set your KOVAN_RPC_URL and PRIVATE_KEY environment variables. You can get the RPC URL by creating a free account on infura (https://infura.io/), and you can get the private key from your metamask wallet (or any other wallet) (I'd create a dummy account you only use on testnets).
