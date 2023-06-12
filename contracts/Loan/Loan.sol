// SPDX-License-Identifier:MIT
pragma solidity 0.8.20;

contract Loan{

    // WETH "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2"
    // USDT "0xdAC17F958D2ee523a2206206994597C13D831ec7"

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

       // 轉入數量到這個合約，先鎖住
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
    function totalSupply() external view returns (uint);

    function balanceOf(address account) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

// instance
contract ERC20 is IERC20{
    uint public totalSupply = 10 ** 18;
    mapping(address => uint) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;
    string public name = "USD Jim";
    string public symbol = "USDJ";
    uint8 public decimals = 18;

    constructor(){
        balanceOf[msg.sender] = 100000;
    }

    function transfer(address recipient, uint amount) external returns (bool) {
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool) {
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function mint(uint amount) external {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    function burn(uint amount) external {
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }
}