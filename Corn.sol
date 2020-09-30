// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.2.0/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.2.0/contracts/token/ERC20/IERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.2.0/contracts/token/ERC20/SafeERC20.sol";

contract Corn is ERC20 {
    
    using SafeERC20 for IERC20;
    using SafeMath for uint256;
 
    address owner;
    address private fundVotingAddress;
    IERC20 private kernels;
    bool private isSendingFunds;
    uint256 private lastBlockSent;

    modifier _onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    constructor() public payable ERC20("Corn.finance", "CORN") {
        owner = msg.sender;
        uint256 supply = 32000;
        _mint(msg.sender, supply.mul(10 ** 18));
        lastBlockSent = block.number;
    }
    
    function setKernelsAddress(address kernelsAddress) public _onlyOwner {
        kernels = IERC20(kernelsAddress);
    }    
    
    function setFundingAddress(address fundingContract) public _onlyOwner {
        fundVotingAddress = fundingContract;
    }
   
    function startFundingBool() public _onlyOwner {
        isSendingFunds = true;
    }
   
    function getFundingPoolAmount() public view returns(uint256) {
        kernels.balanceOf(owner);
    }
   
    function triggerTransfer(uint256 amount) public {
        require((block.number - lastBlockSent) > 21600, "Too early to transfer");
        kernels.safeTransfer(fundVotingAddress, amount);
    }
    
}

