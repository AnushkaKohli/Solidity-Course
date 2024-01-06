// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0 <0.9.0;

contract ComputerCompany {
    // dynamic type array of that type of object to keep track of the objects created
    Desktop[] public desktops;

    // This function deploys a new instance of the Desktop Contract and stores its address for future reference.
    function create() public {
        // We cannot keep track of the created objects in this way. Which desktop object has been created or how many desktop objects have been created, we cannot keep a track of al of this.
        // Desktop desktop = new Desktop();

        //So to keep track of these objects - whenever you are creating an object then create a dynamic type array of that type of object
        desktops.push(new Desktop());
        //This is how instances of our deployed contract are created each time we deploy the contract
    }
}

contract Desktop {}
