// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// OpenZeppelin is a library for secure smart contract development.
// 1. Implementations of standards like ERC20 and ERC721.
// 2. Flexible role-based permissioning scheme.
// 3. Reusable Solidity components to build custom contracts and complex decentralized systems.

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract GLDToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("Gold", "GLD") {
        _mint(msg.sender, initialSupply);
    }
}
