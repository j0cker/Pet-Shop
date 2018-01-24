pragma solidity ^0.4.11;

contract petShop {

    // State variables of the articles
    address seller;
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
      address indexed _seller,
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
        string _name,
        string _description,
        uint256 _price) {
        return(seller, name, description, price);
    }

}
