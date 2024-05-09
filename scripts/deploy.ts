// import { deployContractFromName } from "../utils";
import { ethers } from "hardhat";
import { Flasloanbot, Flasloanbot__factory } from "../typechain";

async function main() {
  // const flasloanbot: Flasloanbot = await deployContractFromName(
  //   "Flashloanbot",
  //   Flasloanbot__factory
  // );
  // await flasloanbot.deployed();

  const balancerVaultAddress = "0xBA12222222228d8Ba445958a75a0704d566BF2C8";


  const flashloanbotFactory: Flasloanbot__factory = await ethers.getContractFactory("Flasloanbot") as Flasloanbot__factory;
  const flashloanbot: Flasloanbot = await flashloanbotFactory.deploy(balancerVaultAddress);
  await flashloanbot.deployed();
  

  console.log("contract deployed to:", flashloanbot.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
