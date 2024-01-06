// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0 <0.9.0;

contract Company {
    // Add a mapping to store the addresses of all the instances of contracts
    mapping(string => address) public register;

    function contractCall() public {
        register["HR"] = address(new HR());
        register["CEO"] = address(new CEO());
        register["Manager"] = address(new Manager());
        HR(register["HR"]).A();
    }
}

contract HR {
    function A() public pure {}
}

contract CEO {}

contract Manager {

}

// Factory pattern is used to create multiple instances of the same contract
// Name registry pattern is used to store the addresses of all the instances of the contracts
