const hre = require("hardhat");
var chai = require('chai')
var expect = chai.expect
 
describe("Lottery", function () {
  it("The wallet should be the main one!", async function () {
    const wallet = '0xec001D225966Af2b4F0E7d5b79aa9455B2a1149a';
    const subscriptionId = '585';
    const Lock = await hre.ethers.getContractFactory("Lottery");
    const lock = await Lock.deploy(subscriptionId);
    const checkWallet = await lock.mainWallet();
    expect(wallet).to.equal(checkWallet);
  });
});
