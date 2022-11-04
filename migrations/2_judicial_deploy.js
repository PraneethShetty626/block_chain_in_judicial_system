const Judicial = artifacts.require("./contracts/Judicial.sol");

module.exports = function (deployer) {
  deployer.deploy(Judicial);
};

