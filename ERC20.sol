// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0 <0.9.0;

interface ERC20Interface {
    function totalSupply() external view returns (uint);

    function balanceOf(address tokenOwner) external view returns (uint balance);

    function transfer(address to, uint tokens) external returns (bool success);

    function allowance(
        address tokenOwner,
        address spender
    ) external view returns (uint remaining);

    function approve(
        address spender,
        uint tokens
    ) external returns (bool success);

    function transferFrom(
        address from,
        address to,
        uint tokens
    ) external returns (bool);

    // Emitted when `tokens` no of tokens are moved from one account (from) to another (to). Note that value may be zero.
    event Transfer(address indexed from, address indexed to, uint tokens);
    // Emitted when the allowance of a `spender` for a `tokenOwner` is set by a call to `approve`. `tokens` is the new allowance.
    event Approval(
        address indexed tokenOwner,
        address indexed spender,
        uint tokens
    );
}

contract Block is ERC20Interface {
    string public name = "Block"; //Name of the token
    string public symbol = "BLK"; //Symbol of the token
    uint public decimals = 0; //Upto how many decimal places the token can be divided, generally its 18
    // Returns the amount of tokens in existence.
    uint public override totalSupply; //Total supply of the token
    address public founder; //The address of the founder, where the tokens will be sent initially
    mapping(address => uint) public balances; //A mapping to keep track of the token balance of each address
    mapping(address => mapping(address => uint)) allowed; //A mapping to keep track of the allowance of the token

    constructor() {
        totalSupply = 100000;
        founder = msg.sender;
        balances[founder] = totalSupply;
    }

    // Returns the amount of tokens owned by `tokenOwner`.
    function balanceOf(
        address tokenOwner
    ) public view override returns (uint balance) {
        return balances[tokenOwner];
    }

    // Moves `tokens` no of tokens from the caller’s account to `to` 's account. Returns a boolean value indicating whether the operation succeeded Emits a `Transfer` event.
    function transfer(
        address to,
        uint tokens
    ) public override returns (bool success) {
        require(balances[msg.sender] >= tokens && tokens > 0);
        balances[to] += tokens;
        balances[msg.sender] -= tokens;
        emit Transfer(msg.sender, to, tokens);
        return true;
    }

    // Sets `tokens` as the allowance of `spender` over the caller’s tokens. Returns a boolean value indicating whether the operation succeeded. Emits an Approval event.
    // To approve if the spender can spend the tokens on behalf of the owner ensuring that the owner has enough balance
    function approve(
        address spender,
        uint tokens
    ) public override returns (bool success) {
        require(balances[msg.sender] >= tokens);
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    // Returns the remaining number of tokens that `spender` will be allowed to spend on behalf of `tokenOwner` through `transferFrom`. This is zero by default. This value changes when `approve` or `transferFrom` are called.
    function allowance(
        address tokenOwner,
        address spender
    ) public view override returns (uint noOfTokens) {
        return allowed[tokenOwner][spender];
    }

    // Moves `tokens` no of tokens from `from` account to `to` account using the allowance mechanism. `tokens` is then deducted from the caller’s allowance. Returns a boolean value indicating whether the operation succeeded. Emits a Transfer event.
    function transferFrom(
        address from,
        address to,
        uint tokens
    ) public override returns (bool success) {
        require(allowed[from][to] >= tokens);
        require(balances[from] >= tokens);
        balances[from] -= tokens;
        balances[to] += tokens;
        allowed[from][to] -= tokens;
        emit Transfer(from, to, tokens);
        return true;
    }
}
