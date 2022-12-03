// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./ICryptoDevs.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract CryptoDevToken is ERC20, Ownable {
    uint256 public constant maxTotalSupply = 10000 * 10 ** 18;
    uint256 public constant tokensPerNFT = 10 * 10 ** 18;
    uint256 public constant pricePerToken = 0.001 ether;
    ICryptoDevs cryptoDevsNFT;
    AggregatorV3Interface internal priceFeed;
    bool _pause;
    mapping(uint256 => bool) public tokenIdsClaimed;

    constructor(
        address nft_contract
    ) ERC20("Nikhils Crypto Dev Tokens", "NCDT") {
        cryptoDevsNFT = ICryptoDevs(nft_contract);
        priceFeed = AggregatorV3Interface(
            0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
        );
    }

    modifier notPaused() {
        require(!_pause, "minting is paused");
        _;
    }

    function mint(uint256 amount) public payable {
        uint256 _requiredAmount = pricePerToken * amount;
        require(
            msg.value >= _requiredAmount,
            " please provide sufficient ethers"
        );
        uint256 amountWithDecimals = amount * 10 ** 18;
        require(
            (totalSupply() + amountWithDecimals) <= maxTotalSupply,
            "Exceeds the max total supply available."
        );
        _mint(msg.sender, amountWithDecimals);
    }

    function claim() public {
        address sender = msg.sender;
        uint256 balance = cryptoDevsNFT.balanceOf(sender);
        require(balance > 0, " you dont have NFT any more");
        uint256 amount = 0;
        for (uint256 i = 0; i < balance; i++) {
            uint256 tokenId = cryptoDevsNFT.tokenOfOwnerByIndex(sender, i);

            if (!tokenIdsClaimed[tokenId]) {
                amount += 1;
                tokenIdsClaimed[tokenId] = true;
            }
        }
        require(amount > 0, "You have already claimed all the tokens");

        _mint(msg.sender, amount * tokensPerNFT);
    }

    function setPause() public onlyOwner {
        _pause = true;
    }

    function setPauseOff() public onlyOwner {
        _pause = false;
    }

    function getLatestPrice() public view returns (int, uint8) {
        (
            ,
            /*uint80 roundID*/ int price /*uint startedAt*/ /*uint timeStamp*/ /*uint80 answeredInRound*/,
            ,
            ,

        ) = priceFeed.latestRoundData();
        uint8 decimals = priceFeed.decimals();
        return (price, decimals);
    }

    function withdraw() public onlyOwner {
        uint256 amount = address(this).balance;
        require(amount <= 0, "nothing to withdraw");
        address _owner = owner();

        (bool sent, ) = _owner.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }

    receive() external payable {}

    fallback() external payable {}
}
