// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0 <0.9.0;

contract demo {
    mapping(address => uint) balance;

    function requestEther(address payable receiver) public payable {
        // As soon as transfer is executed, the fallback function of the receiver is called because we are changing the state of the smart contract but not calling any function of the smart contract.
        // Now, the fallback function of the receiver can call the requestEther function again before the balance of the receiver is updated. This can be done recursively and the receiver can drain the balance of the smart contract. This is called re-entrancy attack.
        receiver.transfer(balance[receiver]);
        balance[receiver] = 0;

        // To prevent this, we can update the balance of the receiver before transferring the ether. So even if the fallback function of the receiver is called, the balance of the receiver will be zero and the receiver will not be able to drain the balance of the smart contract. It is similar to the withdraw pattern.
        uint amount = balance[receiver];
        balance[receiver] = 0;
        receiver.transfer(amount);
    }
}

contract ReentrancyAttack {
    demo victim;

    fallback() external payable {
        victim.requestEther(payable(msg.sender));
    }
}
