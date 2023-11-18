// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() { 
  const Register = await hre.ethers.getContractFactory("Register");
  const register = await Register.deploy();

  await register.deployed();

  register.on("Registered", (_address, _name, _time) => {
    console.log(`New Registration:${_address} registered ${_name} on ${_time} `);
  })

  register.on("Updated", (_address, _name, _time) => {
    console.log(`New name Update:  ${_address} update name to ${_name} on ${_time} `);
  })

  register.on("UpdateApproved", (_address, _initialName, _newName, _time) => {
    console.log(`Name Update approved:  ${_address} update from ${_initialName} to ${_name} on ${_time} `);
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
