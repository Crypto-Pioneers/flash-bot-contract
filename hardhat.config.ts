import { config as dotEnvConfig } from "dotenv";
dotEnvConfig();
import "@nomiclabs/hardhat-etherscan";
import "@nomiclabs/hardhat-waffle";
import "@nomiclabs/hardhat-ethers";
import "@typechain/hardhat";
import "@openzeppelin/hardhat-upgrades";
import "solidity-coverage";

const config = {
  // defaultNetwork: "sepolia",
  networks: {
    hardhat: {
    },
    mumbai: {
      url: "https://polygon-mumbai.g.alchemy.com/v2/Jx0noqyrJNYrfVoBk97uQFJ_OlgL2juD",
      accounts: ['d180f7649f382e01bd785dce311671b4e83efc68205be5bc9c0c63d77a167d4d']
    },
    goerli: {
      url: "https://goerli.infura.io/v3/7b469035cb45417084f3f4433f10a8ae",
      accounts: ['1a05c2fb4a78cf5b4fa8c51630339cda1553f941db75791158aaf55cdf713267']
    },
    sepolia: {
      url: "https://sepolia.infura.io/v3/9262ebaabe4842b392b39b54cda79f9b",
      accounts: ['91c45b9775584a7e80075b8f755540f48ab5820739e41fc4fcd26a5720714afb']
    },
    base_mainnet: {
      url: "https://mainnet.base.org",
      accounts: ['91c45b9775584a7e80075b8f755540f48ab5820739e41fc4fcd26a5720714afb']
    },
  },
  solidity: {
    version: "0.8.4",
    settings: {
        optimizer: {
          enabled: true,
          runs: 200,
        },
    }
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts"
  },
  mocha: {
    timeout: 40000
  },
  etherscan: {
    apiKey: {
      sepolia: "SCYJEQWSS2B48PZXSK3SK9MEVMW48GB1KY"
    },
  },
}

module.exports = config;
