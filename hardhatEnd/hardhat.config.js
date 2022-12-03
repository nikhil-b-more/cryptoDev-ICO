require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config({ path: ".env" });

const PVK = process.env.PRIVATE_KEY;
const URL = process.env.HTTP_URL;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.17",
  networks: {
    goerli: {
      url: URL,
      accounts: [PVK],
    },
  },
};
