// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract THICCNFT is ERC721, Ownable {
    using Strings for uint256;
    using Address for address;

    uint64 private _maxSupply = 5555;

    uint64 private _totalNftMinted = 155;
    uint64 private _reserve = 155;
    uint64 private _totalOwnerMinted;

    uint64 public _mintPerWhiteList = 5;
    uint64 public _mintPerUser = 5;
    uint64 private _mintPerOwner= 5;

    address private _owner;
    string private baseURI;
    string private _baseExtension = ".json";
    
    bool private revealed = false;
    string private notRevealedUri;
    bool public isMintEnabled;
    bool public isWhiteListEnable;

    struct Details {
        address users;
        uint256[] tokenIds;
    }

    uint256 private mintPriceForUser = 0.069 ether ;
    uint256 private mintPriceForWhiteListUser = 0.0420 ether ;
  

    
    mapping(address => Details) private _userTokenIds;
    mapping(address => bool) public _ownerAddress;

    mapping(address => bool) public whitelistedAddresses;


    constructor(string memory _initNotRevealedUri) ERC721("Thicc Frens", "THICCFRENS") {
        _owner = msg.sender;
        isWhiteListEnable = true;
        _ownerAddress[msg.sender]=true;
        setNotRevealedURI(_initNotRevealedUri);
        


    }
    modifier zeroAddress(address _account) {
        require(_account != address(0), "address can't be zero address");
        _;
    }
    

    // only owner
    // This function is used to update the presale supply.
    function setMaxWhiteListSupply(uint8 _amount) external onlyOwner {
        _mintPerWhiteList = _amount;
    }

    // This function is used to update the public supply.
    function setMaxPublicSupply(uint8 _amount) external onlyOwner {
        _mintPerUser = _amount;
    }
    // This function is used to update the public supply.
    function setMaxOwnerSupply(uint8 _amount) external onlyOwner {
        _mintPerOwner = _amount;
    }

    // please pass the value in wei.
    function setMintPriceForUser(uint256 _price) external onlyOwner {
        require(_price > 0, "Price must greater then zero. ");
        mintPriceForUser = _price;
    }

    // please pass the value in wei.
    function setMintPriceForWhiteListUser(uint256 _price) external onlyOwner {
        require(_price > 0, "Price must greater then zero. ");
        mintPriceForWhiteListUser = _price;
    }

    // Here we can pass address in array format.
    function setWhiteListUserInBatch(address[] memory _account)
        external
        onlyOwner
        returns (bool)
    {
        require(_account.length <= 100,"Array length must be less then 100" );
        for (uint256 i = 0; i < _account.length; i++) {
            address userAddress = _account[i];
            whitelistedAddresses[userAddress] = true;
        }
        return true;
    }

    // Here we can pass address in array format.
    function setOwnerWhiteList(address[] memory _account)
        external
        onlyOwner
        returns (bool)
    {
        require(_account.length <= 100,"Array length must be less then 100" );
        for (uint256 i = 0; i < _account.length; i++) {
            address userAddress = _account[i];
            _ownerAddress[userAddress] = true;
        }
        return true;
    }

    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }

    function setMaxSupply(uint64 _setValidTokenIds) external onlyOwner {
        _maxSupply = _setValidTokenIds;
    }

    function removeWhiteListUser(address _account) external onlyOwner zeroAddress(_account) {
        require(whitelistedAddresses[_account] == true);
        whitelistedAddresses[_account] = false;
    }
    function removeOwnerWhiteList(address _account) external onlyOwner zeroAddress(_account) {

        _ownerAddress[_account] = false;
    }

    function toggleWhiteList() external onlyOwner {
        isWhiteListEnable = !isWhiteListEnable;
    }

    function mintEnabled() external onlyOwner {
        isMintEnabled = !isMintEnabled;
    }

    function reveal() external onlyOwner {
        revealed = true;
    }

    function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
        notRevealedUri = _notRevealedURI;
    }
    function totalMintNft() external view onlyOwner returns(uint256){
        return _totalNftMinted;
    }
    function OwnerTotalMintNft() external view onlyOwner returns(uint256){
        return _totalOwnerMinted;
    }
    // internal
    
    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    function ownerMint(uint256 _quantity) internal {
        address user = msg.sender;
        require(_ownerAddress[user], " You are not owner.");
        uint256 checkToken= _userTokenIds[msg.sender].tokenIds.length;
        checkToken= checkToken+_quantity;
        require(checkToken <=_mintPerOwner,"Mint limit exceeded.");
        uint256 supply = _totalOwnerMinted;
        require((supply + _quantity) <= _reserve, "All _reserve NFTs are minted");
        for (uint256 i = 1; i <= _quantity; i++) {
            uint256 ids = supply + i;
            _safeMint(user, ids);
            _totalOwnerMinted++;
            Details storage newDetails = _userTokenIds[user];
            newDetails.users = user;
            newDetails.tokenIds.push(ids);
        }
    }

    // public functions
    function mint(uint256 _quantity) external payable {
        require(_quantity >= 1 && _quantity <= 5   ,"Invalid argument.");
        require(isMintEnabled, "minting not enabled");
        address user = msg.sender;
        require(user != address(0), "address can't be zero address");

        if (_ownerAddress[user]) {
            ownerMint(_quantity);
        } else {
            uint256 supply = _totalNftMinted;
            require((supply + _quantity) <= _maxSupply, "All NFTs are minted");

            if (isWhiteListEnable) {
                require(
                    _quantity <= _mintPerWhiteList,
                    "Please enter valid tokenIds."
                );
                require(
                    whitelistedAddresses[msg.sender],
                    "You are not whiteListed."
                );
                uint256 checkToken= _userTokenIds[msg.sender].tokenIds.length;
                checkToken= checkToken+_quantity;

                require(
                    checkToken <=
                        _mintPerWhiteList,
                    "Your mint limit exceed."
                );
                uint256 mintFee = estimateFee(_quantity);
                require(
                    msg.value >= mintFee,
                    "Please enter asking price for mint NFT."
                );
                Address.sendValue(payable(_owner), mintFee);
                for (uint256 i = 1; i <= _quantity; i++) {
                    uint256 ids = supply + i;
                    _safeMint(user, ids);
                    _totalNftMinted++;
                    Details storage newDetails = _userTokenIds[user];
                    newDetails.users = user;
                    newDetails.tokenIds.push(ids);
                }
            } else {
                require(
                    _quantity <= _mintPerUser,
                    "Please enter valid tokenIds."
                );

                uint256 checkToken= _userTokenIds[msg.sender].tokenIds.length;
                checkToken= checkToken+_quantity;
                require(
                    checkToken <= _mintPerUser,
                    "Your mint limit exceed."
                );
                uint256 mintFee = estimateFee(_quantity);
                require(msg.value >= mintFee, "Please enter minting price.");
                Address.sendValue(payable(_owner), mintFee);
                for (uint256 j = 1; j <= _quantity; j++) {
                    uint256 ids = supply + j;
                    _safeMint(user, ids);
                    _totalNftMinted++;
                    Details storage newDetails = _userTokenIds[user];
                    newDetails.users = user;
                    newDetails.tokenIds.push(ids);
                }
            }
        }
    }
    function estimateFee(uint256 tokenId) public view returns (uint256) {
        if (isWhiteListEnable) {
            return mintPriceForWhiteListUser * tokenId;
        } else {
            return mintPriceForUser * tokenId;
        }
    }

    function owner() public view virtual override returns (address) {
        return _owner;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        if (revealed == false) {
            return notRevealedUri;
        }

        string memory currentBaseURI = _baseURI();
        return
            bytes(currentBaseURI).length > 0
                ? string(
                    abi.encodePacked(
                        currentBaseURI,
                        tokenId.toString(),
                        _baseExtension
                    )
                )
                : "";
    }

    function getUserTokenIds() external view returns (uint256[] memory) {
        Details memory d=  _userTokenIds[msg.sender];
        return d.tokenIds;

    }

    // check which price is set for nft.
    function currentNftPrice() external view returns (uint256) {
        if (isWhiteListEnable) {
            return mintPriceForWhiteListUser;
        }
        return mintPriceForUser;
    }
    function checkReveal() external view returns(bool){
        return revealed;
    }
    function checkNonRevealUrl() external view returns(string memory){
        return notRevealedUri;
    }
    function gerBaseUri() external view returns(string memory){
        return baseURI;
    }
    // This function is gives total number of NFT minted.
    function getTotalMintedNFT() external view returns(uint256){
        uint256 userMint =  _totalNftMinted - 155 ;
        uint64 ownerMinted=_totalOwnerMinted;
        return userMint + ownerMinted;
    }
}