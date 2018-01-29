//test before mapping

// Contract to be tested
var petShop = artifacts.require("./petShop.sol");

// Test suite
contract('petShop', function(accounts) {
  var petShopInstance;

  //these variables are going to be tested into the sell function in order to se that these variables work.
  var seller = accounts[1];
  var articleName = "article 1";
  var articleDescription = "Description for article 1";
  var articlePrice = 10;



  // Test case: sell an article
  it("should sell an article", function() {
    return petShop.deployed().then(function(instance) {
      petShopInstance = instance;
      return petShopInstance.sellArticle(articleName, articleDescription, web3.toWei(articlePrice, "ether"), {
        from: seller
      });
    }).then(function() {
      return petShopInstance.getArticle.call();
    }).then(function(data) {
      assert.equal(data[0], seller, "seller must be " + seller);
      assert.equal(data[1], articleName, "article name must be " + articleName);
      assert.equal(data[2], articleDescription, "article descriptio must be " + articleDescription);
      assert.equal(data[3].toNumber(), web3.toWei(articlePrice, "ether"), "article price must be " + web3.toWei(articlePrice, "ether"));
    });
  });
});
