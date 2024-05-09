import { ethers } from "hardhat";
import { Flashloanbot, Flashloanbot__factory } from "../typechain";

async function main() {

  const balancerVaultAddress = "0xBA12222222228d8Ba445958a75a0704d566BF2C8";


  const flashloanbotFactory: Flashloanbot__factory = await ethers.getContractFactory("Flashloanbot") as Flashloanbot__factory;
  const flashloanbot: Flashloanbot = await flashloanbotFactory.deploy(balancerVaultAddress);
  await flashloanbot.deployed();
  

  console.log("contract deployed to:", flashloanbot.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
