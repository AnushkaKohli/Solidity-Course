# Design Patterns and Security
- Once smart contracts are deployed on blockchain, you cannot make changes to the smart contract. So solidity suggests with some designs and patterns to make the smart contract more secure.
- The secure, efficient design of smart contracts is importannt, given that millions of dollars are tied up in smart contracts and dApp functions.
- To avoid costly errors, it's a good idea to rely on proven smart contract design patterns.
- Smart contract design patterns are reusable, repeatable solutions in writing code. They can serve a wide range of purposes, but can be seen as offering four main functions:
    1. Security patterns – To protect your contract against breaches.
    2. Efficiency patterns – To reduce the cost of executing your contract.
    3. Access control patterns – To manage who can execute the functions of your contract.
    4. Contract management patterns – To organize your contracts and how they interact.

## Security patterns
Security patterns are designed to maximize the level of security of a smart contract against any risk. They are used to ward off reentrancy attacks, overflow attacks, or the flawed behavior of the actual smart contracts.
Examples of security design patterns are:
1. Balance limit pattern
2. Pull over push payments
3. Secure ether transfer
4. Fork check
5. Termination
6. Math pattern
7. Time constraint
8. Mutex pattern
9. Auto deprecation design pattern
10. Withdrawal pattern

## Efficiency Patterns
Efficiency patterns optimize the operation of a smart contract or reduce the costs associated with using one. Using these patterns can save time and money for operators and users. Examples of efficiency patterns are :
1. Use libraries
2. Incentive execution
3. Tight variable packing
4. Limit storage
5. Challenge response
6. Write values
7. Pull payments
8. Publisher-subscriber
9. Avoid redundant operations
10. Short constant strings
11. Fail early and fail loud
12. Limit modifiers
13. Minimize on-chain data
14. Low contract footprint

## Access Control Patterns
Access control patterns restrict who can access and execute certain functions of the smart contract. This way, you can manage permissions and authorizations for a given function, like giving only the admin the ability to do something. The ability to restrict access is particularly useful on a public blockchain ledger, where anyone can see the contract, but you want to control who can do what within the contract. Examples of restricting access patterns include:
1. Hash secret
2. Access restriction
3. Judge
4. Embedded permission
5. Dynamic binding

## Contract Management Patterns
Contract management patterns refer to how contract owners organize their smart contracts and how the contracts work together. Examples of contract management patterns include :
1. Migration
2. Data contract
3. Contract decorator
4. Inter-family communication
5. Flyweight
6. Contract registry
7. Contract mediator
8. Satellite
9. Contract observer

### Factory Pattern
This pattern is used to efficiently manage multiple instances of similar contracts on the Ethereum blockchain. Factory contract is used to create and deploy “child” contracts. Those child contracts can be referred to as “assets” which in the real life could represent, say, a house or a car.

In the context of Ethereum smart contracts, factory pattern involves creating a separate contract responsible for deploying other contracts. Think of it as a contract that acts as a factory, churning out instances of another contract with predefined functionalities and structures.

#### Why Use the Factory Pattern?
🔧 Efficiency: Deploying multiple instances of a contract individually can be costly in terms of gas fees and time. The Factory Pattern optimizes this process by centralizing contract creation, resulting in significant gas savings.

📈 Scalability: When your decentralized application (DApp) requires the creation of numerous instances of similar contracts, managing them individually becomes cumbersome. The Factory Pattern simplifies contract management, making it more scalable.

🛠️ Code Reusability: With the Factory Pattern, you can reuse the factory contract code across different projects, reducing redundancy and ensuring consistency.

### Mapping Iterator

Many times we need to iterate a mapping, but since mappings in Solidity cannot be iterated and they only store values, the Mapping Iterator pattern turns out to be extremely useful. 
So whenever we are creating a mapping, we should also create a dynamic array of that type of object to keep track of the objects created.

### Withdrawl Pattern
#### The Problem
In Solidity, a standard way of sending Ether to an address is by using the send() or transfer() functions. The difference between both functions is that transfer() will throw an exception if something goes wrong with the transaction while send() will not throw but simply return a boolean false. However, using these functions to send Ether directly can pose a significant risk. If the receiving contract contains a fallback function, this could be executed, leading to unexpected behaviour, including the potential for reentrancy attacks. This attack could drain Ether from the original contract.

#### The Solution
The Withdrawal Pattern mitigates this risk by changing the way Ether is transferred. Instead of directly pushing Ether to recipient contracts, they can withdraw their funds. This pattern separates the action of initiating payment and the withdrawal process into two distinct stages.

By storing Ether within the contract, the control is shifted from the sender to the receiver, making it the receiver’s responsibility to initiate the withdrawal. This separation restricts the ability of the receiving contract to interact with the sending contract during the transfer process, significantly reducing the risk of a reentrancy attack.

### Name Registry
Imagine you are building a DApp which has a dependency on multiple contracts, for example a blockchain copy of Amazon store, which makes use of ClothesFactoryContract, GamesFactoryContract, BooksFactoryContract, etc.. Now imagine keeping all those addresses inside your app’s code. What if those addresses change over time or even more annoying, while developing you are deploying all those contracts every time you make changes and you have to keep track of their addresses. This is where Name Registry comes into play. This pattern allows you to only keep the address of one contract, instead of tens, hundreds or even thousands, as your DApp grows in scale. It works by storing a mapping contract name => contract address. The benefit of storing names mapped to addresses is that with the introduction of new versions of some contracts the DApp will not be affected in any way since the only thing we modify is just the address of the mapping.

## Re-entrancy Attack
Reentrancy attack in solidity repeatedly withdraws funds from the smart contract and transfers them.

#### Problematic Code
As soon as transfer is executed, the fallback function of the receiver is called because we are changing the state of the smart contract but not calling any function of the smart contract.

Now, the fallback function of the receiver can call the requestEther function again before the balance of the receiver is updated. This can be done recursively and the receiver can drain the balance of the smart contract. This is called re-entrancy attack.
```
function requestEther(){
    address.transfer(balance);
    balance[address] = 0;
}
```
#### Attackers Code
```
fallback external payable {
    requestEther();
}
```
#### Solution Code
We can update the balance of the receiver before transferring the ether.
```
function requestEther(){
    uint temp = balance[address];
    balance[address] = 0;
    address.transfer(temp);
}
```