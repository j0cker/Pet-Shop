pragma solidity ^0.4.11;

contract petShop {

    //lets physically group a set of variables,
    //belonging to the same concept.
    //this is not going to store anything in the
    //contract state until we instantiate of this type
    //and store it in the state.
    struct Article {

      uint id;
      // State variables of the articles
      address seller;

      //at the begining is 0 and then this will change when the purchase
      //is confirmed
      address buyer;

      string name;
      string description;
      uint256 price;

    }

    /*
    mappings are associative arrays whose values are set to zero for all possible
    keys by default, but values can be any data type including custom structure
    types. Mappings cannot be interated over, because they are not stored as
    such in the contract state. Theres no way to know the size of the
    mapping or to determine if a ket exists or not. the only thing we can do
    is changing the value asociated to a key or retrieving the value
    asociated to a known key.
    */

    //this will generate a list of articles identified by their own id.
    //so we can access to an article trough their id.
    //we have declare a public articles with that the compiler is goign to
    //generate automatically a getter method which is going to
    //return the values of the article but not generate setter's functions.
    mapping(uint => Article) public articles;
    //this variable is going to help us keep track of the mapping
    //to know how many articles we have.
    uint articleCounter;
    //owner of the contract
    address owner;

    /*
    These simple Variables are going to be replaced by the struct types.
    // State variables of the articles
    address seller;
    //at the begining is 0 and then this will change when the purchase
    //is confirmed
    address buyer;
    string name;
    string description;
    uint256 price;
    */


    //events
    event sellArticleEvent(

      //variables of mapping and Structure
      uint indexed _id,

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

      //variables of mapping and Structure
      uint indexed _id,

      address indexed _seller,
      address indexed _buyer,

      string _name,
      uint256 _price
    );

    //constructor asign owner address at the beginning of the contract.
    function petShop() {
      owner = msg.sender;
    }


    /*
    // constructor -> create a default article
    function petShop() {
        sellArticle("Default article", "This an article set by default", 1000000000000000000);
    }
    */

    // sell an article. This will change the state of the contract so it whas a cost.
    function sellArticle(string _name, string _description, uint256 _price) public {

      /*
      These variables are going to be replaced by
      Structure and mapping.

        seller = msg.sender;
        name = _name;
        description = _description;
        price = _price;
      */

        //increment the counter variables of articles mapping
        articleCounter++;

        //store the article into the mapping.
        articles[articleCounter] = Article (
        	articleCounter,
        	msg.sender,
        	0x0,
        	_name,
        	_description,
        	_price
        );

        sellArticleEvent(articleCounter, msg.sender, _name, _price);

        //before mapping
        //sellArticleEvent(articleCounter, msg.sender, name, price);
    }

    //with mapping the getArticle function is not require due to
    //mapping cause it is going to generate the get method of the
    //article automatically. But we need the get function of the
    //get number of articles which is different of the get articles.
    //and get all article IDs available for sale

    //fetch the number of mapping articles in the contract
    function getNumberOfArticles() public constant returns (uint){
    	return articleCounter;
    }


    // fetch and returns all article IDs available for sale
    function getArticlesForSale() public constant returns (uint[]) {
      // we check whether there is at least one article

      if(articleCounter == 0){
        return new uint[](0);
      }

      //this will throw an exception at the beginning
      //require(articleCounter > 0);



      // prepare intermediary array
      //this will contain identifiers of the articles
      //here is just a declaration of the array and
      //we are telling it that the max size is the articleCounter variable.
      uint[] memory articleIds = new uint[](articleCounter);

      //this will help us later to have the right size of the sale articles.
      uint numberOfArticlesForSale = 0;

      // iterate over articles
      for (uint i = 1; i <= articleCounter; i++) {
        // keep only the ID of articles not sold yet
        if (articles[i].buyer == 0x0) {
          articleIds[numberOfArticlesForSale] = articles[i].id;
          numberOfArticlesForSale++;
        }
      }

      // copy the articleIds array into the smaller forSale array
      uint[] memory forSale = new uint[](numberOfArticlesForSale);
      for (uint j = 0; j < numberOfArticlesForSale; j++) {
        forSale[j] = articleIds[j];
      }
      return (forSale);
    }


    /*
    //without the mapping and structure.

    // get the article. Calling this function will be free.
    function getArticle() public constant returns (
        address _seller,
        address _buyer,
        string _name,
        string _description,
        uint256 _price) {
        return(seller, buyer, name, description, price);
    }

    */

    // buy an article
    //lets put a payable function which means that
    //it may recieve value in the form of ether from its caller
    //if you dont declare variables as payable, you cannot send value
    //to it

    //with mapping and Structure
    function buyArticle(uint _id) payable public {

    //without mapping and structure
    //function buyArticle() payable public {

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

      //check if there is in the mapping at least one article
      require(articleCounter>0);

      //we check that the _id article counter of mapping exists
      require(_id>0 && _id<=articleCounter);

      //we retrieve the article from the mapping.
      //this is goinf to store the article into the contract state.
      Article storage article = articles[_id];

      // we check that the article was not already sold

      require(article.buyer == 0x0);

      //before the mapping
      //require(buyer == 0x0);

      //we don't allow the seller to buy its own article

      require(article.seller != msg.sender);

      //before the mapping
      //require(msg.sender != seller);

      //we check whether the value sent corresponds to the article price

      require(article.price == msg.value);

      //before the mapping
      //require(msg.value == price);


      // if everything is ok
      // keep buyer's information (sender as the buyer)

      article.buyer = msg.sender;

      //before the mapping
      //buyer = msg.sender;

      // the buyer can buy the article
      //we send money to the seller
      //this value comes from the value of the contract,
      //thanks to the payable function

      article.seller.transfer(msg.value);

      //before the mapping
      //seller.transfer(msg.value);

      // trigger the event

      buyArticleEvent(_id, article.seller, article.buyer, article.name, article.price);

      //before the mapping
      //buyArticleEvent(seller, buyer, name, price);
    }

    //kill the smart contract
    function kill(){
      require(owner == msg.sender);
      selfdestruct(owner);
    }

}
