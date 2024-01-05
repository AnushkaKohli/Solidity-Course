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
    ) public virtual override returns (bool success) {
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
    ) public virtual override returns (bool success) {
        require(allowed[from][to] >= tokens);
        require(balances[from] >= tokens);
        balances[from] -= tokens;
        balances[to] += tokens;
        allowed[from][to] -= tokens;
        emit Transfer(from, to, tokens);
        return true;
    }
}

contract ICO is Block {
    address public manager;
    // Address at which the investors will deposit their ethers
    address payable public deposit;

    uint tokenPrice = 0.1 ether; // Price of each token in ethers
    uint public cap = 300 ether; // Maximum no of ethers to be raised
    uint public raisedAmount; // Amount of ethers raised
    uint public icoStart = block.timestamp;
    uint public icoEnd = icoStart + 3600; // ICO will run for 1 hour (in seconds)
    uint public tokenTradeTime = icoEnd + 3600; // Tokens can be traded 1 hour after the ICO ends
    uint public minInvestment = 0.1 ether; // Minimum investment required
    uint public maxInvestment = 10 ether; // Maximum investment allowed
    enum State {
        beforeStart,
        afterEnd,
        running,
        halted
    } // State of the ICO
    State public icoState; // Current state of the ICO
    event Invest(address investor, uint value, uint tokens);

    constructor(address payable _deposit) {
        deposit = _deposit;
        manager = msg.sender;
        icoState = State.beforeStart;
    }

    modifier onlyManager() {
        require(msg.sender == manager);
        _;
    }

    function halt() public onlyManager {
        icoState = State.halted;
    }

    function resume() public onlyManager {
        icoState = State.running;
    }

    function changeDepositAddress(
        address payable newDeposit
    ) public onlyManager {
        deposit = newDeposit;
    }

    function getState() public view returns (State) {
        if (icoState == State.halted) {
            return State.halted;
        } else if (block.timestamp < icoStart) {
            return State.beforeStart;
        } else if (block.timestamp >= icoStart && block.timestamp <= icoEnd) {
            return State.running;
        } else {
            return State.afterEnd;
        }
    }

    function invest() public payable returns (bool) {
        icoState = getState();
        require(icoState == State.running);
        require(msg.value >= minInvestment && msg.value <= maxInvestment);
        raisedAmount += msg.value;
        require(raisedAmount <= cap);
        uint tokens = msg.value / tokenPrice;
        balances[msg.sender] += tokens;
        balances[founder] -= tokens; // Coming from block contract
        deposit.transfer(msg.value);
        emit Invest(msg.sender, msg.value, tokens);
        return true;
    }

    // Burning the tokens is done to effectively reduce the total supply of the token. This is done to increase the value or the demand of the token.
    function burn() public returns (bool) {
        icoState = getState();
        require(icoState == State.afterEnd);
        balances[founder] = 0;
        return true;
    }

    // This function is used to transfer the tokens after the ICO ends. This function is overridden from the block contract.
    function transfer(
        address to,
        uint tokens
    ) public override returns (bool success) {
        require(block.timestamp > tokenTradeTime);
        // Calling the transfer function of the parent contract ie the block contract
        super.transfer(to, tokens); // You can also use Block.transfer(to, tokens);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint tokens
    ) public override returns (bool success) {
        require(block.timestamp > tokenTradeTime);
        Block.transferFrom(from, to, tokens);
        return true;
    }

    // If the investor is unaware of the invest() function and sends ethers directly to the contract address, all hisethers will be lost. So the fallback function will be called that will call the invest() function.
    receive() external payable {
        invest();
    }
}
