// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0 <0.9.0;

contract MappingIterator {
    mapping(address => uint) public values;

    // To solve the problem, a mapping iterator is used in the form of a dynamic array of addess type which keeps track of the addresses that is calling the pay function
    address[] public addresses;

    function pay(uint _value) public {
        // This way we are unable to keep track of the addresses that is calling the pay function
        values[msg.sender] = _value;
        addresses.push(msg.sender);
    }

    function returnArray() public view returns (address[] memory) {
        return addresses;
    }

    // So whenever we are creating a mapping, we should also create a dynamic array of that type of object to keep track of the objects created
}
