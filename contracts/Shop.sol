// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 ;

contract Shop{

    string public shopName ;
    uint public count = 0;

    constructor() {
        shopName = "Mr Bebo Shop";
    }

    struct Product {
        uint id;
        string name;
        string description;
        bool sold;
        address  payable owner;
        uint price;
    }

      event CreateProduct (
        uint id,
        string name,
        string description,
        bool solded,
        address  payable owner,
        uint price
   );

        event PurchsedProduct (
        uint id,
        string name,
        string description,
        bool solded,
        address  payable owner,
        uint price
   );


    mapping (uint =>Product) public shopProducts;


    function createShopProduct(string  memory name, uint price, string memory description) public {

       require(price>0,"The price Shoud be More Than  or equal 1");
       require(bytes(name).length > 0,"Your Name Is empty");
        require(bytes(description).length > 0,"Your Description Is empty");
        count++;
        shopProducts[count]=Product(count,name,description,false,payable (msg.sender),price);

        emit CreateProduct(count,name,description,false,payable (msg.sender),price);


    }

    function purchasedShopProduct(uint _id) public payable {
        Product memory singleProduct  = shopProducts[_id];
        address payable seller = singleProduct.owner;

        require(seller != msg.sender,"can`t Buy your Product");
        require(msg.value >= singleProduct.price,"the value not equal price of the product");
        require(singleProduct.id >0 &&singleProduct.id <= count ,"the id should be more than zero");
        require(!singleProduct.sold,"This Item Solded");

        singleProduct.owner = payable(msg.sender);
        singleProduct.sold = true;
        shopProducts[_id]=singleProduct;
          payable( seller).transfer(msg.value);
      emit PurchsedProduct(_id,singleProduct.name,singleProduct.description,true,payable (msg.sender),singleProduct.price);

    }

}

