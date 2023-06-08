// SPDX-License-Identifier:MIT
pragma solidity 0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Loan is ERC20{

    address immutable owner;

    // 10 min
    uint8 loanTime = 10;
    
    // 3% 利息，抵押物品
    int8 rate = 3;

    struct LoanData{
        address guarantyCoin;
        address borrowCoin;
        int guarantyAmount;
        int borrowAmount;
        bool approve;
    }

    // 怎麼紀錄交易對才好?
    mapping (int => mapping (address => LoanData)) CreatedLoanLog;

    modifier IsOwner {
        require(owner == msg.sender,"invalid");
        _;
    }

    constructor(address _owner){
        owner = _owner;
    }

    //新增想借貸的
    function createLoan(address _guarantyCoin,address _borrowCoin) public {
        ERC20 guarantyCoin = IERC20(_guarantyCoin);
        ERC20 borrowCoin = IERC20(_borrowCoin);
        // mapping 怎麼新增
        // CreatedLoanLog[][]
    }

    function approveLoanData() {
        
    }

    function withdrawalLoan() public{

    }
}

interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
   
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address to, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}