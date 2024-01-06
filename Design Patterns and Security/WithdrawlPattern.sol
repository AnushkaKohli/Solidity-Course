// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0 <0.9.0;

contract WithdrawlPattern {
    address payable richest;
    // To solve the problem, we create a mapping
    mapping(address => uint) investors;
    uint max;

    constructor() payable {
        richest = payable(msg.sender);
        max = msg.value;
        richest.transfer(msg.value);
    }

    function sendEther() public payable {
        require(msg.value > max, "You are not the richest person.");
        richest = payable(msg.sender);
        max = msg.value;
        // richest.transfer(msg.value);
        investors[msg.sender] = msg.value;
    }

    // Withdraw function is called by the user to withdraw the ether sent to the contract. But again, the fallback function is called and the contract reverts the transaction. So the user cannot withdraw the ether sent to the contract but the max value and richest value are updated successfully
    function withdraw() public {
        uint amount = investors[msg.sender];
        investors[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }
}

// When demo sends ether to the contract, the fallback function is called because of `richest.transfer(msg.value);` and the contract reverts the transaction meaning even if demo is the richest person, the max value and richest value will not be updated
contract demo {
    function A() public pure {
        uint a = 5;
    }

    // sendEther();
    // withdraw();

    fallback() external payable {
        revert();
    }
}

// Whenever both transfer and withdrawl of ether is taking place in the same contract, the withdrawl pattern is used to prevent the reentrancy attack. And two separate functions are used for transfer and withdrawl of ether.
