# Pet-Shop
Ethereum Smart Contract Dapp into the Blockchain using Truffle.

now open a console and start the command:

testrpc

go to your project directory:

cd ChainSkills/Training/Pet-Shop

add into the truffle.js archive the following:

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  networks: {
  development: {
  host: "localhost",
  port: 8545,
  network_id: "*"
  }
  }
};

we are going to create a new file into the migrations directory that is going to be called: 2_deploy_contracts.js. under that document we will add the following:

var Greetings = artifacts.require("./petShop.sol");
  module.exports = function(deployer) {
  deployer.deploy(Greetings);
};

nota: the number to at the beginning of the name of the contract is needed, cause truffle is going to follow that number in order to identify the process.

truffle migrate //it will run the contract
