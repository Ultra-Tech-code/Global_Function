// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.17 and less than 0.9.0
pragma solidity ^0.8.17;



contract PaidRegister {
    //2 ether for registration
    //1 ether for update

    //Nb: string returns [object object] if indexed but returns the right value when not indexed so i won't be indexing the string events
    event Registered(address indexed _address, string _name, uint indexed _gasUsed);
    event Updated(address indexed _address, string _name, uint indexed _gasUsed);
    event Viewed(address indexed _address, string _name);
    event UpdateApproved(address indexed _address, string _initialName, string _newName, uint indexed _time);

    address owner;
    uint256 public registrationFee = 2 ether;
    uint256 public updateFee = 1 ether;

    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "NOT OWNER!!");
        _;
    }

    mapping(address => string) registered;
    mapping(string => bool) nameTaken;
    mapping(address => bool) addressTaken;

    mapping(address => bool) updateNeeded;
    mapping(address => string) updatedName;

    function registerName(string memory name) external payable {
        uint256 startGas = gasleft();
        require(bytes(name).length > 0, "Name cannot be empty");
        require(msg.sender != address(0), "Zero Address");
        require(nameTaken[name] == false && addressTaken[msg.sender] == false, "Taken!!");
        require(msg.value >= registrationFee, "Insufficient Funds");
        registered[msg.sender] = name;

        nameTaken[name] = true;
        addressTaken[msg.sender] = true;

        uint256 gasUsed = startGas - gasleft();

        emit Registered(msg.sender, name, gasUsed);

    }
    
    function updateName(string memory newName) external payable {
        uint256 startGas = gasleft();
        require(bytes(newName).length > 0, "Name cannot be empty");
        require(addressTaken[msg.sender], "Address have no name, Register!!" );
        require(msg.value >= updateFee, "Insufficient Funds");

        updateNeeded[msg.sender] = true;
        updatedName[msg.sender] = newName;
        nameTaken[newName] = true;

        uint256 gasUsed = startGas - gasleft();

        emit Updated(msg.sender, newName, gasUsed);

    }

    function approveUpdate(address nameAddress) external onlyOwner{
        require(updateNeeded[nameAddress], "No update needed");
        string memory initialName = registered[nameAddress];
        nameTaken[initialName] = false;

        string memory newName = updatedName[nameAddress];

        updateNeeded[nameAddress] = false;
        updatedName[nameAddress] = "";
        registered[nameAddress]= newName;

        emit UpdateApproved(nameAddress, initialName, newName, block.timestamp);  
    }

    function viewName(address nameAddress) public {
        require(addressTaken[nameAddress], "Address have no name, Register!!" );

        emit Viewed(nameAddress, registered[nameAddress]);
    }
}