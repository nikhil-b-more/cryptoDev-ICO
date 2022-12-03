const { ethers } = require("hardhat");
const hre = require("hardhat");
const { CRYPTO_NFT_ADDRESS } = require("../Constants");

async function main() {
  const cryptoDevsTokenContract = await ethers.getContractFactory(
    "CryptoDevToken"
  );

  const deployToken = await cryptoDevsTokenContract.deploy(CRYPTO_NFT_ADDRESS);
  await deployToken.deployed();
  console.log(deployToken.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

// 0x5FbDB2315678afecb367f032d93F642f64180aa3 ave lot of ethers

// 0xb35f6f4A7CEf3D121C64394eE148b34c4dD85Aa9 updated
