var LeasablePlane = artifacts.require("./LeasablePlane.sol")


var web3_utils = require("web3-utils");

module.exports = function(deployer, _network, _accounts) {
    deployer.deploy(LeasablePlane, 
        'BAR234');
    deployer.deploy(LeasablePlane, 
        'BAR235');
};
