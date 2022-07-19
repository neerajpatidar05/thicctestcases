// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "hardhat/console.sol";


contract Staking is  ERC721Holder {
  
    using Address for address; 
    using SafeMath for uint256;
    using Strings for uint256; 

    // uint256[] public rarityThree= [1,2, 3, 4, 5, 6, 7, 8, 9, 1,0 ,11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100,1,2, 3, 4, 5, 6, 7, 8, 9, 1,0 ,11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100 ];
    // ["1","2", "3", "4", "5", "6", "7", "8", "9", "10" ,"11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59", "60", "61", "62", "63", "64", "65", "66", "67", "68", "69", "70", "71", "72", "73", "74", "75", "76", "77", "78", "79", "80", "81", "82", "83", "84", "85", "86", "87", "88", "89", "90", "91", "92", "93", "94", "95", "96", "97", "98", "99", "100" ];

    
    IERC20 public thicctoken;
    ERC721 public thiccNft;
    address private _owner;
    uint256 public _totalThiccStake;
    uint256 public _totalNftStake;
    
    uint256 public _ThiccCounter;
    uint256 public _NftCounter;
    
//  IERC20 _thicctoken,ERC721 _NftContract
// uint256[] memory tokenIds
    constructor(IERC20 _thicctoken,ERC721 _NftContract) {
        _owner= msg.sender;
        thicctoken = _thicctoken;
        thiccNft= _NftContract;
        // addRarityThree(tokenIds);
    }
     struct StakeNftDetails {
        address staker;
        uint256 stakeId;
        uint256 tokenIds;
        uint256 startingTime;
    }


    struct StakeThiccDetails {
        address staker;
        uint256 stakeId;
        uint256 amount;
        uint256 startingTime;
    }
    // NFT mapping
    mapping(address => uint256[]) public nftUserID;
    mapping(address => mapping(uint256 => StakeNftDetails)) public stakenftdetails;
    
    // Thicc mapping
   mapping(address => uint256[]) public thiccUserID;
   mapping(address => mapping(uint256 => StakeThiccDetails)) public stakethiccdetails;

//    mapping(uint256 =>bool) public rarityThree;

   /******Events******/
   event StakeNft(address indexed staker,uint256 indexed id);

   event StakeThicc(address indexed staker,uint256 indexed id,uint256 amount);

    modifier onlyOwner() {
        require(
            _owner== msg.sender,

            "Ownable: caller is not the _owner"
        );
        _;
    }
    // Here we can pass address in array format.
    // function addRarityThree(uint256[] memory tokenIds)
    //     public
    //     returns (bool)
    // {
    //     for (uint256 i = 0; i < tokenIds.length; i++) {
    //         uint256 userAddress = tokenIds[i];
    //         rarityThree[userAddress] = true;
    //     }
    //     return true;
    // }




    // This function is to stake nft.
    // while staking NFT first we have to give approval to staking contract address.
    function stakeNFT(uint256 _tokenId) external { 
        require(thiccNft.ownerOf(_tokenId)==msg.sender,"You're not owner of this token.");
        address staker=msg.sender;
        thiccNft.safeTransferFrom(msg.sender, address(this), _tokenId );
        _NftCounter++;
        _totalNftStake++;
        
        nftUserID[staker].push(_NftCounter); // Update in Thicc Id Map


        StakeNftDetails storage s = stakenftdetails[staker][_NftCounter];

        s.staker = staker;
        s.stakeId = _NftCounter;
        s.tokenIds = _tokenId ;
        s.startingTime = block.timestamp;
        
        // _totalNftStake += _totalNftStake;
        emit StakeNft(staker,_tokenId);
    } 
   


    // This function is to unstake nft.

    function unstakeNFT(uint256 id) external {
         address staker=msg.sender;
         StakeNftDetails storage s = stakenftdetails[staker][id];
         require(isIdNFTExist(staker,id) == true,"Invalid ID");
         // Calculate End Time
        uint256 startTime= s.startingTime;
        uint256 sevenDays = startTime + 2 minutes;
        uint256 fifteenDays = startTime + 3 minutes;
        uint256 thirtyDays = startTime + 5 minutes;
        console.log("line number 98");
        uint256 tokenIds = s.tokenIds;
        // requestVolumeData(tokenIds);
        console.log("line number 101");

        if( block.timestamp >= sevenDays  && block.timestamp < fifteenDays){
            // uint256 reward = 1 * volume;
            uint256 reward = 1;
            uint256 rewardAmount = reward * 10**9;
            thiccNft.safeTransferFrom( address(this),staker, tokenIds);
            thicctoken.transfer(staker,rewardAmount);
            
            console.log("line number 109");
             // Reset Map & Array
            delete stakenftdetails[staker][id];
            deleteNFTUserIds(staker,id);
            console.log("line number 113");
            _totalNftStake--;
            return;
        }
        else if(block.timestamp >= fifteenDays && block.timestamp < thirtyDays  ){
            uint256  commissionPercentage=25;
            uint256 commissionby=10;
            // reward =   2.5 * rarity
            // uint256 reward = (commissionPercentage/commissionby) * volume;
            uint256 reward = (commissionPercentage/commissionby);

            uint256 rewardAmount = reward * 10**9;
            
            console.log("line number 123");
            thiccNft.safeTransferFrom( address(this),staker, tokenIds);
            thicctoken.transfer(staker,rewardAmount);
            // _totalNftStake -=_totalNftStake;
            delete stakenftdetails[staker][id];
            deleteNFTUserIds(staker,id);
            console.log("line number 129");
            _totalNftStake--;
            return;
        
        }
        else if( block.timestamp >= thirtyDays ) {
            console.log("line number 134");

                //  uint256 reward = 7 * volume;
                 uint256 reward = 7;

                 uint256 rewardAmount = reward * 10**9;

                thiccNft.safeTransferFrom( address(this),staker, tokenIds);
                 thicctoken.transfer(staker,rewardAmount);
                 _totalNftStake--;
                
                delete stakenftdetails[staker][id];
                deleteNFTUserIds(staker,id);
                console.log("line number 144");
                return;

            }
            console.log("line number 148");
            thiccNft.safeTransferFrom( address(this),staker, tokenIds);
            delete stakenftdetails[staker][id];
            deleteNFTUserIds(staker,id);
            console.log("line number 152");
            _totalNftStake--;
            return;
        } 
     
    function stakeTHICC(uint256 _amount) public {
        _amount= _amount * 10** 9;
        address staker=msg.sender;
        require(thicctoken.balanceOf(staker) >= _amount,"You have insufficient THICC.");
        thicctoken.transferFrom(msg.sender,address(this),_amount);
        _ThiccCounter++;
        thiccUserID[staker].push(_ThiccCounter); // Update in Thicc Id Map

        StakeThiccDetails storage s = stakethiccdetails[staker][_ThiccCounter];

        s.staker = staker;
        s.stakeId = _ThiccCounter;
        s.amount = _amount;
        s.startingTime = block.timestamp;

        _totalThiccStake+= _amount;
        emit StakeThicc(staker,_ThiccCounter,_amount);
    }
    // This function is used to stake THICC ERC20 Token.
    function unstakeTHICC(uint256 id) external {
        address staker = msg.sender;
        StakeThiccDetails storage s = stakethiccdetails[staker][id];
        require(isIdThiccExist(staker,id) == true,"Invalid ID");
        require(s.amount != 0,"Already Unstake For This ID");

        // Calculate End Time
        uint256 startTime= s.startingTime;
        uint256 sevenDays = startTime + 30 seconds;
        uint256 fifteenDays = startTime + 35 seconds;
        uint256 thirtyDays = startTime + 3 minutes;
        console.log("225");

        console.log("Unstake Amount Before",s.amount);
        uint256 unstakeamount = s.amount; //100 
        console.log("Unstake Amount",unstakeamount);
        console.log("230");
       if(block.timestamp >= sevenDays && block.timestamp < fifteenDays){
                // uint256 commissionPercentage=100;
                // uint256 commissionby=1000;
                // uint256 rewardAmount= unstakeamount *commissionPercentage /commissionby;
                uint256 rewardAmount= 1 * 10**9;

                console.log("7 days.....",rewardAmount);
                uint256 totalAmount= rewardAmount + unstakeamount;
                console.log("239",totalAmount);
                thicctoken.transfer(staker,totalAmount);
                console.log("240");
                 // Reset Map & Array
                 delete stakethiccdetails[staker][id];
                _totalThiccStake-= unstakeamount;
                console.log("245");
                deleteTHICCUserIds(staker,id);
                return;
                

        }
        else if(block.timestamp >= sevenDays && block.timestamp < thirtyDays){
            console.log("15 days...........");

                // uint256 commissionPercentage=250;
                // uint256 commissionby=1000;
                // uint256 rewardAmount= unstakeamount * commissionPercentage/commissionby;
                uint256 rewardAmount= 2 * 10**9;

                console.log("Line 104 Reward Amount",rewardAmount);
                uint256 totalAmount= rewardAmount+unstakeamount;
                thicctoken.transfer(staker,totalAmount);
                 // Reset Map & Array
                 console.log("262",unstakeamount);
                 delete stakethiccdetails[staker][id];
                _totalThiccStake-= unstakeamount;
                deleteTHICCUserIds(staker,id);
                return;
               
                }
                else if( block.timestamp >= thirtyDays)
                {
                    console.log("30 days........");

                // uint256 commissionPercentage=700;
                // uint256 commissionby=1000;
                // uint256 rewardAmount= unstakeamount * commissionPercentage/commissionby;
                uint256 rewardAmount= 7 * 10**9;
                console.log("Line 113 Reward Amount",rewardAmount);
                console.log("276");
                uint256 totalAmount= rewardAmount+unstakeamount;
                 thicctoken.transfer(staker,totalAmount);
                 // Reset Map & Array
                console.log("280");
                delete stakethiccdetails[staker][id];
                _totalThiccStake-= unstakeamount;
                console.log("283");
                deleteTHICCUserIds(staker,id);
                console.log("285");
                return;
            
             }

             console.log("less then 7 days" );
            thicctoken.transfer(staker,unstakeamount);
              // Reset Map & Array
            delete stakethiccdetails[staker][id];
            console.log("294");
            _totalThiccStake-= unstakeamount;
            deleteTHICCUserIds(staker,id);
            return;
    }

    function deleteTHICCUserIds(address _account, uint256 userIds) internal returns(bool) {
        uint256[] storage array = thiccUserID[_account];

        if(array.length == 1){
            array.pop();
            return true;
        }


        uint256 index;

        for (uint256 i = 1; i < array.length; i++) {
            if(array[i]==userIds){
                index = i;
                break;
            }
        
        }
        array[index] = array[array.length-1];
        array.pop();

        return true;
    }
    function deleteNFTUserIds(address _account, uint256 userIds) internal returns(bool) {
        uint256[] storage array = nftUserID[_account];

        if(array.length == 1){
            array.pop();
            return true;
        }


        uint256 index;

        for (uint256 i = 1; i < array.length; i++) {
            if(array[i]==userIds){
                index = i;
                break;
            }
        
        }
        array[index] = array[array.length-1];
        array.pop();

        return true;
    }
    function ContractThiccBalance() external view onlyOwner returns(uint256){
        return thicctoken.balanceOf(address(this));
    }


    function isIdThiccExist(address user,uint256 id) internal view returns(bool){
        uint256[] memory arr = thiccUserID[user];
        for(uint256 j=0;j<arr.length;j++){
            if(arr[j]==id)
            return true;
        }
        return false;
    }
    function isIdNFTExist(address user,uint256 id) internal view returns(bool){
        uint256[] memory arr = nftUserID[user];
        for(uint256 j=0;j<arr.length;j++){
            if(arr[j]==id)
            return true;
        }
        return false;
    }
    
    
    receive() external payable {}


    function getUserThiccIds(address _account) public view returns(uint256[] memory){
        
        return thiccUserID[_account];
    }

     function getUserNftIds(address _account) public view returns(uint256[] memory){
        
        return nftUserID[_account];
    }

    function getUserThiccDetails(address _account) external view returns(address[] memory, uint256[] memory,uint256[] memory,uint256[] memory){

        uint256[] memory userIds = thiccUserID[_account];

        address[] memory adddress = new address[](userIds.length);
        uint256[] memory userId = new uint256[](userIds.length);
        uint256[] memory amount = new uint256[](userIds.length);
        uint256[] memory startingTime = new uint256[](userIds.length);

        for (uint256 i = 0; i < userIds.length; i++) {
            uint256 id= userIds[i];
            StakeThiccDetails storage s1 = stakethiccdetails[_account][id];
            adddress[i] = s1.staker;
            userId[i] = s1.stakeId;
            amount[i] = s1.amount;
            startingTime[i] = s1.startingTime;
        }
        return (adddress, userId,amount,startingTime);
     }

    function getUserNftDetails(address _account) external view returns(address[] memory, uint256[] memory,uint256[] memory,uint256[] memory){

        uint256[] memory userIds = nftUserID[_account];

        address[] memory adddress = new address[](userIds.length);
        uint256[] memory userId = new uint256[](userIds.length);
        uint256[] memory tokenIds = new uint256[](userIds.length);
        uint256[] memory startingTime = new uint256[](userIds.length);

        for (uint256 i = 0; i < userIds.length; i++) {
            uint256 id= userIds[i];
            StakeNftDetails storage s1 = stakenftdetails[_account][id];
            adddress[i] = s1.staker;
            userId[i] = s1.stakeId;
            tokenIds[i] = s1.tokenIds;
            startingTime[i] = s1.startingTime;
        }
        return (adddress, userId,tokenIds,startingTime);
     }
}