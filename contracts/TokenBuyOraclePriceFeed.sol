// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract TokenBuyOraclePriceFeed is Ownable {
    event claim(address indexed userAddress);

    IERC20 public usdtToken;
    IERC20 public token;

    uint256 public price;
    uint256 public startTime;
    uint256 public endTime;
    address public tokenWallet;
    address public fundingWallet;

    AggregatorV3Interface public priceFeed;

    mapping(address => uint256) public userTokens;

    constructor(
        address _usdtToken,
        address _token,
        address _tokenWallet,
        address _fundingWallet,
        address _priceFeed
    ) Ownable(msg.sender) {
        usdtToken = IERC20(_usdtToken); // setting the usdt token
        token = IERC20(_token); //token Address
        tokenWallet = _tokenWallet; //wallet having test tokens
        fundingWallet = payable(_fundingWallet); //funding wallet to recieve usdt;
        price = 2e6; //setttting the token price in usdt
        startTime = block.timestamp; //start time
        endTime = block.timestamp + 7 days; //end timess
        priceFeed = AggregatorV3Interface(_priceFeed); //chainLinkPricFeed
    }

    function getLatestPrice() public view returns (uint256) {
        (, int256 priceValue, , , ) = priceFeed.latestRoundData(); //gettting only price
        return uint256(priceValue);
    }
     
    //function for buying tokens with eth
    function ethBuying() public payable {
        require(startTime > block.timestamp || block.timestamp < endTime); //1 week timee

        require(msg.value > 0, "Value must be greater than 0"); //eth value should be more than 0;

        payable(fundingWallet).transfer(msg.value); //transrring eth to funding wallet

        uint256 cconvertTToUsdt = msg.value * getLatestPrice(); //converting eth to usdt by multipllying with chain link eth/usd pricee; 
        uint256 tokens = cconvertTToUsdt / price; //calculating tokens 
        uint256 totalTokens = tokens / 1e20; // managing the zeros to calculate exact no of tokens

        userTokens[msg.sender] += totalTokens; // adding tokeen to user adddress 

        token.transferFrom(tokenWallet, msg.sender, totalTokens); //transfer to user address from token wallet

        delete userTokens[msg.sender]; // token of usseres = 0
    }

    //funcction for bbuying tokens with usdt
    function usdtBuying(uint256 usdtAmount) public {
        require(usdtAmount > 0); // user shouuld send positivvee amount
        usdtToken.transferFrom(msg.sender, fundingWallet, usdtAmount); // getting usssddt from and sening to funding wallet

        uint256 totalTokens = (usdtAmount * 1e6) / price; // ccalculating total tokens against the usdt 
        userTokens[msg.sender] += totalTokens; // addiing tokens to useer address

        token.transferFrom(tokenWallet, msg.sender, totalTokens); //transfer tokens to user address

        delete userTokens[msg.sender]; //userTokens[] = 0
    }
    
    
    function checkBalance() public view returns (uint256) {
        return IERC20(usdtToken).balanceOf(address(this));
    }

     function getTokenBalance(address _add) public view returns (uint256) {
        return token.balanceOf(_add);
    }
     function getFundingBalance() public view returns (uint256) {
        return IERC20(usdtToken).balanceOf(fundingWallet);
    }
    

    // //function for claiming test tokens
    // function claimTokens(address user) public {
    //     require(userTokens[user] > 0, '"Already Claimed');
    //     uint256 tokenAmount = userTokens[user]; // storing test tokens amount
    //     token.transferFrom(tokenWallet, user, tokenAmount); //transfer to user address

    //     delete userTokens[user];
    // }
}
