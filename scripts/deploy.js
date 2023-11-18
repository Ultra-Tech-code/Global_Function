// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  const PaidRegister = await hre.ethers.getContractFactory("PaidRegister");
  const register = await PaidRegister.deploy();

  await register.deployed();

  register.on("Registered", (_address, _name, _gasUsed) => {
    console.log(`New Registration: ${_address} spent ${_gasUsed} for registering this name: ${_name}`);
  })

  register.on("Updated", (_address, _name, _gasUsed) => {
    console.log(`New name Update:  ${_address} spent ${_gasUsed} for updating name to ${_name} `);
  })

  register.on("UpdateApproved", (_address, _initialName, _newName, _time) => {
    console.log(`Name Update approved:  ${_address} update from ${_initialName} to ${_newName} on ${_time} `);
  })

  register.on("Viewed", (_address, _name) => {
    console.log(`Viewed: ${_address} registered name is ${_name} `);
  })

  console.log(
    `Contract deployed to ${register.address}`
  );

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
