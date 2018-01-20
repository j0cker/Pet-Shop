var petShop = artifacts.require("./petShop.sol");
  module.exports = function(deployer) {
  deployer.deploy(petShop);
};
