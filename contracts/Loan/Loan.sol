// SPDX-License-Identifier:MIT
pragma solidity 0.8.20;

contract Loan{

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
    mapping (int => LoanData) public CreatedLoanLogs;

    mapping (int => address) public LoanMakerLogs;

    int public txnNums = 0;

    modifier IsOwner {
        require(owner == msg.sender,"invalid");
        _;
    }

    constructor(){
        owner = msg.sender;
    }

    //新增想借貸的
    function createLoan(address _guarantyCoin,address _borrowCoin) public {
        IERC20 guarantyCoin = IERC20(_guarantyCoin);
        IERC20 borrowCoin = IERC20(_borrowCoin);

        LoanData memory log;
        
        log =  LoanData({
            guarantyCoin:_guarantyCoin,
            borrowCoin:_borrowCoin,
            guarantyAmount:10,
            borrowAmount:10,
            approve :false
        });
       
       // mapping 怎麼新增 Ans 直接新增，nested也是
       CreatedLoanLogs[txnNums] = log;
       LoanMakerLogs[txnNums] = msg.sender;
       txnNums++;
    }

    function getLoanLog(int txnId) view public returns(address sender,LoanData memory data){
        data = CreatedLoanLogs[txnId];
        sender = LoanMakerLogs[txnId];
    }

    function approveLoanData() public IsOwner{
        
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