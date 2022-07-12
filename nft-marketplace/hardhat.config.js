require("@nomicfoundation/hardhat-toolbox");
const fs = require("fs");
const projectId = process.env.PROJECT_ID
const privateKey = fs.readFileSync(".secret").toString()

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  networks: {
    hardhat: {
      chainId: 1337
    },
    mumbai:{
      url: `https://polygon-mumbai.infura.io/v3/${projectId}`,
      accounts: [privateKey]
    },
    mainnet:{
      url: `https://mainnet.infura.io/v3/${projectId}`,
      accounts: [privateKey]
    }
  },
  solidity: "0.8.9",
};
