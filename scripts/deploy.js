// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {

  const XlyToken = await hre.ethers.getContractFactory("Xly_Token");
  const xlyToken = await XlyToken.deploy();

  await xlyToken.deployed();

  console.log(
    `Xly Token Addess: ${xlyToken.address}`
  );
  
  const EthPool = await hre.ethers.getContractFactory("EthPool");
  const ethPool =  await EthPool.deploy(xlyToken.address);
  await ethPool.deployed();

  console.log(
    `Eth pool Addess: ${ethPool.address}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
