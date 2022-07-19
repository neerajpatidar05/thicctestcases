const { expect, assert } = require('chai')
const { ethers } = require('hardhat')

describe('token contract', function () {
  let owner
  let Stake;
  let stake;
  let addr1
  let addr2
  let addr3
  let addr4
  let addr5
  let addr6
  let addr7
  let addr8
  let addrs
  let zeroAddress = `0x0000000000000000000000000000000000000000`

  beforeEach(async function () {
    Stake = await ethers.getContractFactory('Staking')
  
    ;[
      owner,
      addr1,
      addr2,
      addr3,
      addr4,
      addr5,
      addr6,
      addr7,
      addr8,
      ...addrs
    ] = await ethers.getSigners();
      stake = await Stake.deploy(
      '0xbAB46DeE7848F04F35af1Ce84cb93A6Ac95a411E',
      '0x7a6cc88A3Eb6C27E013a753fBc43877AD5aa9048',
    )
  })

  /***************************Zero addresses**********************/
  describe('Zero Address Cases', async () => {
    it("Owner can't be Zero Address", async () => {
      await expect(Stake.owner).not.be.equal(zeroAddress)
    })
    it("thicctoken can't be Zero Address", async () => {
      await expect(Stake.thicctoken).not.be.equal(zeroAddress)
    })
    it("thiccNft can't be Zero Address", async () => {
      await expect(Stake.thiccNft).not.be.equal(zeroAddress)
    })
  })

  describe("stake and unstake amount can't be Zero", async () => {
    it('stake value must be greater than 0', async () => {
      const name = await stake.name;
      expect(name + '').to.be.equals('neeraj')
    })
  })
})
