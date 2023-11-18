# Starter Hardhat Project for Event Challenge

After cloning the github, you will want to do the following to get the code running on your computer.

1. Inside the project directory, in the terminal type: `npm i`
2. Open two additional terminals in your VS code
3. In the second terminal type: `npx hardhat node`
4. In the third terminal, type: `npx hardhat run --network localhost scripts/deploy.js`
5. Back in the first terminal, type: `npx hardhat console --network localhost`
6. Then we'll use this command to attach our smart contract to our console: 
   `const registerInstance = await (await ethers.getContractFactory("PaidRegister")).attach("0x5FbDB2315678afecb367f032d93F642f64180aa3")`
7. Then we'll use this command to bind our signers to the console  `const signers = await hre.ethers.getSigners();` then `const [deployer, registra, registra2] = signers`
   
   
Once the contract is attached, you can go ahead and call the smart contract functions!

Here is an example you can run using our hardhat provided accounts:

  1. `await registerInstance.connect(registra).registerName("blackadam", {value: hre.ethers.utils.parseEther("2.0")})`
  2. `await registerInstance.connect(registra).updateName("0xblackadam", {value: hre.ethers.utils.parseEther("1.0")})`
  3. `await registerInstance.connect(deployer).approveUpdate(registra.address)`
  4. `await registerInstance.viewName(registra.address)`

[!NOTE] 
string returns [object object] if indexed but returns the right value when not indexed.