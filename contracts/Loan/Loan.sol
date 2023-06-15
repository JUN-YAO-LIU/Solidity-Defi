// SPDX-License-Identifier:MIT
pragma solidity 0.8.20;

contract Loan{

    // WETH "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2"
    // USDT "0xdAC17F958D2ee523a2206206994597C13D831ec7"

    // IERC20 public guarantyCoin;

    // IERC20 public borrowCoin;

    address immutable owner;

    struct LoanData{
        address guarantyCoin;
        address borrowCoin;
        uint guarantyAmount;
        uint borrowAmount;
        bool approve;
        uint8 rate;
        uint8 loanTime;
    }

    // 怎麼紀錄交易對才好?
    mapping (int => LoanData) public CreatedLoanLogs;

    mapping (int => address) public LoanMakerLogs;

    mapping (int => address) public ApproveLoan;

    int public txnNums = 0;

    modifier IsOwner {
        require(owner == msg.sender,"invalid");
        _;
    }

    constructor(){
        owner = msg.sender;
    }

    function approveTrasfer(address _guarantyCoin,uint _guarantyAmount) external {
        IERC20 guarantyCoin = IERC20(_guarantyCoin);
        guarantyCoin.approve(address(this),_guarantyAmount);
    }

    //新增想借貸的
    function createLoan(
        address _guarantyCoin,
        address _borrowCoin,
        uint _guarantyAmount,
        uint _borrowAmount,
        uint8 _rate,
        uint8 _loanTimie) public {

        IERC20 guarantyCoin = IERC20(_guarantyCoin);

        LoanData memory log = LoanData({
            guarantyCoin:_guarantyCoin,
            borrowCoin:_borrowCoin,
            guarantyAmount:_guarantyAmount,
            borrowAmount:_borrowAmount,
            approve :false,
            rate: _rate,
            loanTime:_loanTimie
        });
       
       // mapping 怎麼新增 Ans 直接新增，nested也是
       CreatedLoanLogs[txnNums] = log;
       LoanMakerLogs[txnNums] = msg.sender;
       txnNums++;


       // 轉入數量到這個合約，先鎖住
       // guarantyCoin.approve(address(this),_guarantyAmount);
       guarantyCoin.transferFrom(msg.sender,address(this),_guarantyAmount);

       // event
    }

    function getLoanLog(int txnId) view public returns(address sender,LoanData memory data){
        data = CreatedLoanLogs[txnId];
        sender = LoanMakerLogs[txnId];
    }

    function approveLoanData(int txnId) public {
        ApproveLoan[txnId] = msg.sender;

        LoanData memory log =  CreatedLoanLogs[txnId];
        address loaner  = LoanMakerLogs[txnId];
        
        log.approve = true;
        CreatedLoanLogs[txnId] = log;

        IERC20 borrowCoin = IERC20(log.borrowCoin);
        borrowCoin.transfer(loaner,log.borrowAmount);
    }

    // 回款
    function refund(int txnId) public {
        address borrower = LoanMakerLogs[txnId];
        address lender = ApproveLoan[txnId];
        LoanData memory log =  CreatedLoanLogs[txnId];
        
        // 時間沒有超
        IERC20 borrowCoin = IERC20(log.borrowCoin);
        IERC20 guarantyCoin = IERC20(log.guarantyCoin);

        guarantyCoin.transfer(borrower,log.guarantyAmount * (1 - log.rate / 100));

        guarantyCoin.transfer(lender,log.guarantyAmount * log.rate);
        borrowCoin.transfer(lender,log.borrowAmount);
    }

    // 結算
    function closeLoan(int txnId) public {
        LoanData memory log =  CreatedLoanLogs[txnId];
        address to = ApproveLoan[txnId];
        
        IERC20 guarantyCoin = IERC20(log.guarantyCoin);

        guarantyCoin.transfer(to,log.guarantyAmount);
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
    string public symbol;
    uint8 public decimals = 18;

    constructor(string memory _symbol){
        balanceOf[msg.sender] = 100000;
        symbol = _symbol;
    }

    function transfer(address recipient, uint amount) public returns (bool) {
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

    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        totalSupply += amount;
        balanceOf[account] += amount;
        emit Transfer(address(0), account, amount);
    }
}


contract CustomeToken is ERC20{
   constructor(string memory symbol) ERC20(symbol) {
        _mint(msg.sender, 1000);
    }
}