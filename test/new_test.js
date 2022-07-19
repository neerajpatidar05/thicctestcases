const { expect, assert } = require('chai')
const { ethers } = require('hardhat')

describe('Testcase',  async () => {
  let Stake
  let stake
  let Thicc
  let thicc
  let ThiccNFT
  let thiccnft

  beforeEach(async () => {
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
        addr9,
        addr10,
        addr11,
        ...addrs
      ] = await ethers.getSigners();
       zeroAddress = `0x0000000000000000000000000000000000000000`
    Thicc = await ethers.getContractFactory('THICCETH')
    thicc = await Thicc.deploy()
    ThiccNFT = await ethers.getContractFactory('THICCNFT')
    thiccnft = await ThiccNFT.deploy("revealduri.com")
    Stake = await ethers.getContractFactory('Staking')
    stake = await Stake.deploy((await thicc).address, thiccnft.address)
   await thicc.addstakingContract(stake.address);
   })
  describe("Initial value of variables must be Zero", async () => {
    it('ThiccCounter initialize to zero', async () => {
       let thiccCounter= await stake._ThiccCounter();
  
    expect(thiccCounter).to.be.equals('0');
    
    })
    it('NftCounter initialize to zero', async () => {
    
        let NftCounter= await stake._NftCounter();
      
        expect(NftCounter).to.be.equals('0');
        
        })
    it('totalNftStake initialize to zero', async () => {
    
        let totalNftStake= await stake._totalNftStake();
          
        expect(totalNftStake).to.be.equals('0');
            
      })
      it('totalThiccStake initialize to zero', async () => {
    
        let totalThiccStake= await stake._totalThiccStake();
          
        expect(totalThiccStake).to.be.equals('0');
            
      })
      it('Contract thicc balance  initialize to zero', async () => {
    
        let ContractThiccBalance= await stake.ContractThiccBalance();
          
        expect(ContractThiccBalance).to.be.equals('0');
            
      })

  })
describe("Transfer thicc to Staking Contract",async()=>{
    it("check balance of owner",async()=>{
   
      const balance=  await thicc.balanceOf(owner.address);
        expect(balance.toString()).to.be.equals('900000000000000000000000');
     })

    it("Check Staking contract balance",async()=>{
    const balanceofstake=  await thicc.balanceOf(stake.address);
        expect(balanceofstake).to.be.equals("0");
    })

    it("Transfer token",async()=>{
       await thicc.transfer(addr1.address,2000000000000000);
       const updatebalances=  await thicc.balanceOf(addr1.address);
        expect(updatebalances).to.be.equals("2000000000000000");
     })
})
describe("thiccNft and thiccToken",async()=>{
    it("check  thiccNft address",async()=>{
   
      const thiccnftaddress=  await stake.thiccNft();
       expect(thiccnftaddress).to.be.equals(thiccnft.address);
     })
     it("check  thicctoken address",async()=>{
   
        const thicctokenaddress=  await stake.thicctoken();
        expect(thicctokenaddress).to.be.equals(thicc.address);
       })
    })

    describe('Zero Address Cases', async () => {
    //     it("Owner can't be Zero Address", async () => {
    //       await expect(stake.owner).not.be.equal(zeroAddress)
    //     })
    //     it("thicctoken can't be Zero Address", async () => {
    //       await expect(stake.thicctoken).not.be.equal(zeroAddress)
    //     })
    //     it("thiccNft can't be Zero Address", async () => {
    //       await expect(stake.thiccNft).not.be.equal(zeroAddress)
    //     })
    //   })

    //   describe('thicc stake', async () => {
    //     it("Transfer token from owner to stake pool", async () => {
       
    //     await thicc.transfer(stake.address,100000000000000);
    //     balanceOfowner=  await thicc.balanceOf(owner.address);
    //     expect(balanceOfowner.toString()).to.be.equals('899999999900000000000000');
    //     })

    //     it("Stake from owner's account ", async () => {
       
    //        await thicc.transfer(stake.address,100000000000000);
    //        await stake.connect(owner).stakeTHICC(899999999900000);
    //        balanceOfowner=  await thicc.balanceOf(owner.address);
    //        expect(balanceOfowner).to.be.equals(0);
    //        poolbalance= await thicc.balanceOf(stake.address);
    //        expect(poolbalance.toString()).to.be.equals('900000000000000000000000');
    //         })
            
    //     it("pool balance updated ", async () => {
       
    //             await thicc.transfer(stake.address,100000000000000);
    //             await stake.connect(owner).stakeTHICC(899999999900000);
    //             balanceOfowner=  await thicc.balanceOf(owner.address);
    //             poolbalance= await thicc.balanceOf(stake.address);
    //             expect(poolbalance.toString()).to.be.equals('900000000000000000000000');
    //              })

    //      it("Transfer all balance from owner account to different account ", async () => {

    //         await thicc.transfer(addr1.address,9000000000000000);
    //         await thicc.transfer(addr2.address,9000000000000000);
    //         await thicc.transfer(addr3.address,9000000000000000);
    //         await thicc.transfer(addr4.address,9000000000000000);
    //         await thicc.transfer(addr5.address,9000000000000000);
    //         await thicc.transfer(addr6.address, 9000000000000000);  
    //         await thicc.transfer(addr7.address,9000000000000000); 
    //         await thicc.transfer(addr8.address, 9000000000000000); 
    //         await thicc.transfer(addr9.address, 9000000000000000); 
    //         await thicc.transfer(addr10.address,"899999910000000000000000"); 
    //         await thicc.transfer(addr11.address,9000000000000000);
    //         add1= await thicc.balanceOf(addr1.address);
    //         await expect(add1).to.be.equals(9000000000000000);
    //       })     
    //          it("Stake all token from owner's account", async () => {
            
    //            await stake.connect(owner).stakeTHICC("900000000000000");
    //            balanceOfowner=  await thicc.balanceOf(owner.address);
    //            poolbalance= await thicc.balanceOf(stake.address);
    //            await expect(poolbalance.toString()).to.be.equals('900000000000000000000000');
    //             })
    //     it("Stake from non owner's account", async () => {
    //         await thicc.transfer(addr1.address,9000000000000000);
    //         await thicc.transfer(addr2.address,9000000000000000);
    //         await stake.connect(addr1).stakeTHICC("9000000");
    //         balanceOfowner=  await thicc.balanceOf(owner.address);
    //         poolbalance= await thicc.balanceOf(stake.address);
    //         })
            // it("ThiccCounter is increasing ", async () => {
            //     await thicc.transfer(addr1.address,9000000000000000);
            //     await thicc.transfer(addr2.address,9000000000000000);
            //     await stake.connect(addr1).stakeTHICC("9000000");
            //     balanceOfowner=  await thicc.balanceOf(owner.address);
            //     poolbalance= await thicc.balanceOf(stake.address);
            //     count=await stake._ThiccCounter();
            //     expect(count).to.be.equals(1);

            //     })

            //     it("TotalThiccStake is increasing ", async () => {
            //         await thicc.transfer(addr1.address,9000000000000000);
            //         await stake.connect(addr1).stakeTHICC("9000000");
            //         balanceOfowner=  await thicc.balanceOf(owner.address);
            //         poolbalance= await thicc.balanceOf(stake.address);
            //         count=await stake._totalThiccStake();
            //         expect(count).to.be.equals('9000000000000000');

    
            //         })
            //         it("Details is stored in StakeThiccDetails Struct ", async () => {
            //             await thicc.transfer(addr5.address,9000000000000000);
            //             await stake.connect(addr5).stakeTHICC("9000000");
            //             balanceOfowner=  await thicc.balanceOf(owner.address);
            //             poolbalance= await thicc.balanceOf(stake.address);
            //             count=await stake._totalThiccStake();
            //             expect(count).to.be.equals('9000000000000000');
                      
            //             })


                // it("Staker must have amount greater or equal to Stake amount", async () => {
                //     await thicc.transfer(addr1.address,9000000000000000);
                //     expect( await stake.connect(addr1).stakeTHICC('9000000000000000000')).to.be.reverted;
                //     balanceOfowner=  await thicc.balanceOf(owner.address);
                //     poolbalance= await thicc.balanceOf(stake.address);
                //     console.log(poolbalance,"poolbalance");
                //     console.log(balanceOfowner,"balanceofowner");
                //   })
                 
    })
  

  //  describe("Unstake Thicc",async ()=>{
        // it("Check weather id is exist or not ",async ()=>{
        //        expect(await stake.unstakeTHICC(1)).to.be.reverted;
        // })
//         it("unstake by owner's account ",async ()=>{
//             await thicc.transfer(stake.address,9000000000000000);
//             await stake.connect(owner).stakeTHICC(1000000);
//             function timeout(ms) {
//                 return new Promise(resolve => setTimeout(resolve, ms));
//             }
        
//             await timeout(32000);
//             owneramount= await thicc.balanceOf(owner.address);
//             await stake.connect(owner).unstakeTHICC("1");
//             owneramountafterunstake= await thicc.balanceOf(owner.address);                 

//         })

//         it("unstake by non owner's account ",async ()=>{
//             await thicc.transfer(addr1.address,9000000000000000);
//             await thicc.transfer(stake.address,9000000000000000);
//             await stake.connect(addr1).stakeTHICC(9000000);
//             console.log(await stake.stakethiccdetails(addr1.address,1));
//             console.log(await thicc.balanceOf(stake.address));
          
//             function timeout(ms) {
//                 return new Promise(resolve => setTimeout(resolve, ms));
//             }
        
//             await timeout(36000);
//             console.log(await thicc.balanceOf(addr1.address));
//             await stake.connect(addr1).unstakeTHICC("1");
//             console.log(await thicc.balanceOf(addr1.address));
        
//     })

//     it("ThiccCounter decreased after unstaking ",async ()=>{
//         await thicc.transfer(addr2.address,9000000000000000);
//         await thicc.transfer(stake.address,9000000000000000);
//         await stake.connect(addr2).stakeTHICC(9000000);
//         function timeout(ms) {
//             return new Promise(resolve => setTimeout(resolve, ms));
//         }
    
//         await timeout(36000);
//         console.log(await thicc.balanceOf(addr2.address));
//         await stake.connect(addr2).unstakeTHICC("1");
//         console.log(await thicc.balanceOf(addr2.address));
//        thiccCounter= await stake.connect(addr2)._ThiccCounter();
//        expect(thiccCounter).to.be.equals('1')
    
// })
// it("value of totalThiccStaked decreased after unstaking ",async ()=>{
//     await thicc.transfer(addr2.address,9000000000000000);
//     await thicc.transfer(stake.address,9000000000000000);
//     await stake.connect(addr2).stakeTHICC(9000000);
   
//     function timeout(ms) {
//         return new Promise(resolve => setTimeout(resolve, ms));
//     }

//     await timeout(36000);
//      await stake.connect(addr2).unstakeTHICC("1");
//    thiccStaked= await stake.connect(addr2)._totalThiccStake();
//    expect(thiccStaked).to.be.equals('0')
// })

// it("Getting reward on unstaking ",async ()=>{
//     await thicc.transfer(addr1.address,9000000000000000);
//     await thicc.transfer(stake.address,9000000000000000);
//     await stake.connect(addr1).stakeTHICC(9000000);
//    console.log(await thicc.balanceOf(addr1.address));  
//     function timeout(ms) {
//         return new Promise(resolve => setTimeout(resolve, ms));
//     }

//     await timeout(36000);
//     console.log(await thicc.balanceOf(addr1.address));
//     await stake.connect(addr1).unstakeTHICC("1");
//     balance=await thicc.balanceOf(addr1.address);
//  expect(balance).to.be.equals("9000002000000000");
// })


//})

describe("Stake NFT",async ()=>{
   it("Check mintenabled is working",async ()=>{
   await thicc.transfer(stake.address,"100000");
   await thiccnft.mintEnabled();
   await thiccnft.mint(1);
   balance=await thiccnft.balanceOf(owner.address);
   expect(balance).to.be.equals("1");
})
// it("only owner can call  mintenabled ",async ()=>{
//     await thicc.transfer(stake.address,"100000");
//     expect(await thiccnft.connect(addr1).mintEnabled()).to.be.reverted;
//     await thiccnft.mint(1);
//     balance=await thiccnft.balanceOf(owner.address);
//     expect(balance).to.be.equals("1");
//  })
// it("tokenid is required ",async ()=>{
//     await thicc.transfer(stake.address,"100000");
//     await thiccnft.mintEnabled()
//    // await thiccnft.mint(1);
//    await stake.stakeNFT(1);
//     })

    it("stake from owner account ",async ()=>{
    await thicc.transfer(stake.address,"100000");
    await thiccnft.mintEnabled()
    await thiccnft.mint(3);
    balance=await thiccnft.balanceOf(owner.address);
    expect(balance).to.be.equals("3");
 })
 
 it("stake from non-owner account ",async ()=>{
    await thicc.transfer(stake.address,"100000");
    await thiccnft.mintEnabled()
    await thiccnft.setWhiteListUserInBatch([addr1.address])
    await thiccnft.connect(addr1).mint(5,{value: ethers.utils.parseEther("1")});
    await thiccnft.connect(addr1).approve(stake.address,156)
    await thiccnft.connect(addr1).approve(stake.address,157)
    await thiccnft.connect(addr1).approve(stake.address,158)
    await thiccnft.connect(addr1).approve(stake.address,159)
    await thiccnft.connect(addr1).approve(stake.address,160)
    console.log( await thiccnft.connect(addr1).getUserTokenIds())
    await stake.connect(addr1).stakeNFT(156);
    await stake.connect(addr1).stakeNFT(157);
    await stake.connect(addr1).stakeNFT(158);
    await stake.connect(addr1).stakeNFT(159);
    await stake.connect(addr1).stakeNFT(160);
    console.log( await stake.connect(addr1).getUserNftIds(addr1.address))
    balance=await thiccnft.balanceOf(addr1.address);
    expect(balance).to.be.equals("0");
    
 })
 it("totalNftstake is increased",async ()=>{
    await thiccnft.mintEnabled()
    await thiccnft.setWhiteListUserInBatch([addr2.address])
    await thiccnft.connect(addr2).mint(5,{value: ethers.utils.parseEther("1")});
    await thiccnft.connect(addr2).approve(stake.address,156)
    await thiccnft.connect(addr2).approve(stake.address,157)
    await stake.connect(addr2).stakeNFT(156);
    await stake.connect(addr2).stakeNFT(157);
    totalnftstake=await stake._totalNftStake();
    expect(totalnftstake).to.be.equals("2");
 })
 it("NftCounter is increased",async ()=>{
    await thiccnft.mintEnabled()
    await thiccnft.setWhiteListUserInBatch([addr2.address])
    await thiccnft.connect(addr2).mint(5,{value: ethers.utils.parseEther("1")});
    await thiccnft.connect(addr2).approve(stake.address,156)
    await thiccnft.connect(addr2).approve(stake.address,157)
    await stake.connect(addr2).stakeNFT(156);
    await stake.connect(addr2).stakeNFT(157);
    nftcounter=await stake._NftCounter();
    expect(nftcounter).to.be.equals("2");
 })
})
})