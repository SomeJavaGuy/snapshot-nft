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

Or, run
```
npx hardhat deploy
npx hardhat fund-link --contract {contract address from deployment output}
npx hardhat stake-eth --contract {contract address from deployment output} --amount 0.001
npx hardhat mint-photo --contract {contract address from deployment output} --url {URL of your photo} --title {name your photo!}
npx hardhat unstake-eth
```