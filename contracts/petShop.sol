pragma solidity ^0.4.11;

contract petShop {

    // State variables of the articles
    address seller;

    //at the begining is 0 and then this will change when the purchase
    //is confirmed
    address buyer;

    string name;
    string description;
    uint256 price;

    /*
    // constructor -> create a default article
    function petShop() {
        sellArticle("Default article", "This an article set by default", 1000000000000000000);
    }
    */

    //events
    event sellArticleEvent(
      //lets add indexed (like an índice) which means that we are going
      //to watch only events specific to them
      address indexed _seller,

      string _name,
      uint256 _price
    );

    //event to notify when the purchase has happened
    event buyArticleEvent (
      //lets add indexed (like an índice) which means that we are going
      //to watch only events specific to them
      address indexed _seller,
      address indexed _buyer,

      string _name,
      uint256 _price
    );

    // sell an article. This will change the state of the contract so it whas a cost.
    function sellArticle(string _name, string _description, uint256 _price) public {
        seller = msg.sender;
        name = _name;
        description = _description;
        price = _price;
        sellArticleEvent(seller, name, price);
    }

    // get the article. Calling this function will be free.
    function getArticle() public constant returns (
        address _seller,
        address _buyer,
        string _name,
        string _description,
        uint256 _price) {
        return(seller, buyer, name, description, price);
    }

    // buy an article
    //lets put a payable function which means that
    //it may recieve value in the form of ether from its caller
    //if you dont declare variables as payable, you cannot send value
    //to it
    function buyArticle() payable public {

      // in every require function if doesnt comply,
      // it interrupt the execution of the function and refund
      // to the sender.

      // there are several ways to interrupt a contract function,
      // and those are (throw, assert, require, revert) all
      // do the same, whatever value was sent with the
      // transaction is refunded to the caller, all changes are
      // automatically reverted, when a function execution is
      // interrupted no more gas after this point will be spent,
      // all the gas spent by the message sender up to the point
      // when the function is interrupted is not refunded to the
      // message sender. The basically rollback a transaction.

      // any smart contract has its own balance just like
      // any other account. There are two types of accounts
      // 1 external accounts which have a keeper and can be used
      // by a human users.
      // 2 contract accounts which are linked to deploy contracts
      // when you attach money to a transaction calling a payable
      // function on a contract, you are transferring cryptocurrency
      // from the  balance of your account to the balance of the
      // contract and then any code of the contract, can spend value
      // from its balance by sending or transferring it to another
      // account or it can keep it for later.


      // we check that the article was not already sold
      require(buyer == 0x0);

      //we don't allow the seller to buy its own article
      require(msg.sender != seller);

      //we check whether the value sent corresponds to the article price
      require(msg.value == price);


      // if everything is ok
      // keep buyer's information (sender as the buyer)
      buyer = msg.sender;

      // the buyer can buy the article
      //we send money to the seller
      //this value comes from the value of the contract
      seller.transfer(msg.value);

      // trigger the event
      buyArticleEvent(seller, buyer, name, price);
    }

}
