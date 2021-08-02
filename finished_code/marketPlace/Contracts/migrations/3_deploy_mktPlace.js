var LeasableMarket = artifacts.require("./LeasableMarket.sol")


var web3_utils = require("web3-utils");

module.exports = function(deployer, _network, _accounts) {
    deployer.deploy(LeasableMarket);
 
};
