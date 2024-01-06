// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0 <0.9.0;

contract Assert {
    uint balance;

    function deposit(uint _amount) public {
        balance += _amount;
        assert(balance <= 100);
        // Require is used at the start of the function and does not consume gas but assert is used at the end of the function and consumes gas
    }
}

contract Revert {
    uint balance = 10;

    function callMe(uint _amount) public view returns (uint) {
        // require(_amount < balance, "Balance is less than the amount");
        // return balance;
        if (_amount < balance) {
            return balance;
        } else {
            // It reverts the whole function
            revert("Balance is less than the amount");
        }
    }
}
