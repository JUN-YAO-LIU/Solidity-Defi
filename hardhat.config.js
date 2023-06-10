/** @type import('hardhat/config').HardhatUserConfig */
require("@nomiclabs/hardhat-ethers");
// https://ethereum.stackexchange.com/questions/124085/how-to-configure-ganache-as-network-on-hardhat-config
require("@nomiclabs/hardhat-waffle");

// task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
//   const accounts = await hre.ethers.getSigners();

//   for (const account of accounts) {
//     console.log(account.address);
//   }
// });

const Private_Key = "7022afbae2c6b06fa196bd82b1d0b24ce6beb06e72ad682d50703986008e4f09"

// 不知道測試加networks會不會有影響
module.exports = {
  solidity: "0.7.6",
  hardhat: {
    chainId: 5777,
  },
  networks: {
    ganache: {
      url: "http://127.0.0.1:8545",
      accounts: [
        `0x${Private_Key}`,
      ]
    }
  },
  paths: {
    sources: "./contracts/sample",
  },
};