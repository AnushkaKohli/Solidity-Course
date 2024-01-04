// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

//                      public  private   internal  external
// Outside world        [x]     [ ]       [ ]      [x]        -available after deployment
// Within contract      [x]     [x]       [x]      [ ]
// Derived contracts    [x]     [ ]       [x]      [ ]
// Other contracts      [x]     [ ]       [ ]      [x]

contract Visibility {
    // available outside the contract after deployment
    function f1() public pure returns (uint) {
        f2(); // no error because within the same contract, private is accessible
        f3(); // no error because within the same contract, internal is accessible
        //f4(); // error because within the same contract, external is not accessible
        return 1;
    }

    function f2() private pure returns (uint) {
        return 1;
    }

    function f3() internal pure returns (uint) {
        return 1;
    }

    // available outside the contract after deployment
    function f4() external pure returns (uint) {
        return 1;
    }
}

// Derived contracts- inheriting from Visibility
contract VisibilityDerived is Visibility {
    // f1() and f4() are accesible in the derived contract and also outside the contract after deployment
    uint public x = f3(); //no error because within the derived contract, internal is accessible
    // uint public y = f2(); //error because within the derived contract, private is not accessible
}

contract otherContract {
    Visibility v = new Visibility(); //creating a new instance of Visibility contract
    uint public y = v.f1(); //no error because outside the contract, public is not accessible
    // uint public y = v.f2(); //error because outside the contract, private is not accessible
    // uint public y = v.f3(); //error because outside the contract, internal is not accessible
    uint public z = v.f4(); //no error because outside the contract, external is accessible
}
