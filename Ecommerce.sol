// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0 <0.9.0;

contract Ecommerce {
    struct Product {
        string title;
        string desc;
        address payable seller;
        address buyer;
        uint productId;
        uint price;
        bool delivered;
    }
    Product[] public products;
    uint counter = 1;
    address payable public manager;
    bool destroyed = false;

    modifier isNotDestroyed() {
        require(!destroyed, "Contract is destroyed");
        _;
    }

    constructor() {
        manager = payable(msg.sender);
    }

    event registered(string title, uint productId, address seller);
    event bought(uint productId, address buyer);
    event delivered(uint productId);

    function registerProduct(string memory _title, string memory _desc, uint _price) public isNotDestroyed {
        require(_price > 0, "Price should be gerater than zero");
        Product memory tempProduct;
        tempProduct.title = _title;
        tempProduct.desc = _desc;
        //Price in wei
        tempProduct.price = _price * 10**18;
        tempProduct.seller = payable(msg.sender);
        tempProduct.productId = counter;
        products.push(tempProduct);
        counter++; 
        emit registered(_title, counter, msg.sender);
    }

    //The ether is transferred to the contract first and then when the product is deilvered to the buyer, only then the ether is transferred to the seller
    function buyProduct(uint _productId) payable public isNotDestroyed {
        //If the price of the product is equal to the value sent by the buyer of the product
        require(products[_productId - 1].price == msg.value, "Please pay the exact price of the product");
        require(products[_productId - 1].seller != msg.sender, "Seller cannot buy his own product");
        products[_productId - 1].buyer = msg.sender;
        emit bought(_productId, msg.sender);
    }

    function delivery(uint _productId) public isNotDestroyed {
        require(products[_productId - 1].buyer == msg.sender, "Only buyer can confirm");
        products[_productId - 1].delivered = true;
        products[_productId - 1].seller.transfer(products[_productId - 1].price);
        emit delivered(_productId);
    }

    // function destroy() public {
    //     require(msg.sender == manager, "Only manager can destroy the contract");
    //     //selfdesruct is used to destroy the contract and send all the ether to the manager
    //     //however, selfdestruct function is deprecated and should not be used in production
    //     selfdestruct(manager);
    // }
    function destroy() public isNotDestroyed {
        require(msg.sender == manager, "Only manager can destroy the contract");
        manager.transfer(address(this).balance);
        destroyed = true;
    }

    fallback() external payable {
        //After the contract is destroyed, no one can send ether to the contract. If someone does, the ether is sent back to the sender
        payable(msg.sender).transfer(msg.value);
    }
}