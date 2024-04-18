
const { time } = require("console");
const { setServers } = require("dns");
const { ethers } = require("hardhat");
const { run } = require("hardhat");
async function verify(address, constructorArguments) {
  console.log(
    `verify  ${address} with arguments ${constructorArguments.join(",")}`
  );
  await run("verify:verify", {
    address,
    constructorArguments,
  });
}
async function main() {
  let usdtToken = "0xDb592b20B4d83D41f9E09a933966e0AC02E7421B"; 
  let Token = "0x4040E16930B40bC9447257CC762E255039E3Cd6d"; 
  let testTokenWallet = "0x19A865ab3A6E9DD7ac716891B0080b2cB3ffb9fa"; 
  let fundingWallet = "0x395bFD879A3AE7eC4E469e26c8C1d7BB2F9d77B9"; 
   let priceFeed = "0x694AA1769357215DE4FAC081bf1f309aDC325306";

  


    // const TokenBuyOraclePriceFeed = await ethers.deployContract( 'TokenBuyOraclePriceFeed' , [usdtToken, Token,  testTokenWallet, fundingWallet, priceFeed]);

    //   console.log("Deploying TokenBuyOraclePriceFeed...");
    //   await TokenBuyOraclePriceFeed.waitForDeployment()

    //   console.log("TokenBuyOraclePriceFeed deployed to:", TokenBuyOraclePriceFeed.target);

    //   await new Promise(resolve => setTimeout(resolve, 10000));
  verify("0x2470A882B0E3c2d784c96A2ED47D26Bd80217208",  [usdtToken, Token,  testTokenWallet, fundingWallet, priceFeed]);
}
main();
