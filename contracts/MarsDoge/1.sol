// SPDX-License-Identifier: MIT

pragma solidity >=0.5.0;

interface Itoken{
    //name, symbol, decimals, totalsupply, initialize, 
    //balances, allowance, approve, transfer, 
    //transferfrom, burn, mint, add liquity,

    //tax, burn, mint, are all internal

    //initalize!!
    function name() external pure returns(string memory);
    function symbol() external pure returns(string memory);
    function decimals() external pure returns(uint);
    function totalsupply() external pure returns(uint);
    //returns the balance of user
    function _balanceOf(address user) external view returns(uint);
    // returns amount of allowance for spender
    function allowance(address owner, address spender) external view returns (uint);
    //request approval for spender and amount, owner is msg.sender
    function approve(address spender, uint amount) external returns(bool);
    //from is msg.sender
    function transfer(address to, uint amount) external;
    //spender is msg.sender
    function transferFrom(address from, address to, uint amount) external;
    //add liquity， from is msg.sender, automatic do math??
    function addLiquity(uint amount) external;

    event _transfer(address from, address to, uint amount);
    event _approve(address owner, address spender, uint amount);
    event _liquity(address from, uint token1, uint token2);
}


contract Ownable {
    address private _owner;
    address private _previousOwner;
    uint256 private _lockTime;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () {
        address msgSender = msg.sender;
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == msg.sender, "Ownable: caller is not the owner");
        _;
    }

     /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }

    function geUnlockTime() public view returns (uint256) {
        return _lockTime;
    }


}

//copied
library SafeMath {
    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, 'ds-math-add-overflow');
    }

    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x, 'ds-math-sub-underflow');
    }

    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
    }
}


interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}


interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}


interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}


interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}


contract Basic{
    string public constant _name = "Token";
    string public constant _symbol = "xxx";
    uint public constant _decimals = 18;
    uint public _totalSupply = 10000000;
    bool public fortax = false;
    mapping (address => uint) public balances;
    mapping (address => mapping(address=>uint)) public allowances;
    bool public swapping = false;
}

contract BlackList is Basic, Ownable{
    mapping(address => bool) public blacklist;
    function getBlacklist(address user) public view onlyOwner returns(bool blacklisted){
        return blacklist[user];
    }
    function addBlacklist(address user)public onlyOwner{
        blacklist[user] = true;
        emit addedBL(user);
    }
    function deleteBlacklist(address user)public onlyOwner{
        blacklist[user] = false;
        emit deleteBL(user);
    }
    function burnFunds(address user)public onlyOwner{
        require(getBlacklist(user));
        uint b = balances[user];
        balances[user] = 0;
        _totalSupply -= b;
        emit deleteFunds(user, b);
    }
    event addedBL(address user);
    event deleteBL(address user);
    event deleteFunds(address user, uint256 amount);
}

contract WhiteList is Basic, Ownable{
    mapping(address => bool) public whitelist;
    function getWhitelist(address user) public view onlyOwner returns(bool whitelisted) {
        return whitelist[user];
    }
    function addWhitelist(address user)public onlyOwner{
        whitelist[user] = true;
        emit addedWL(user);
    }
    function deleteWhitelist(address user)public onlyOwner{
        whitelist[user] = false;
        emit deleteWL(user);
    }
    
    event addedWL(address user);
    event deleteWL(address user);
}

contract Token is BlackList, WhiteList {
    using SafeMath for uint;
    IUniswapV2Router02 immutable public _uniswapV2Router;
   //  address immutable public _uniswapV2Pair;

    event _transfer(address from, address to, uint amount);
    event _approve(address owner, address spender, uint amount);
    event AddLiquidity(uint token, uint eth, uint time);
    event _mint(address to, uint amount, uint total);
    event _burn(address from, uint amount, uint total);


    modifier inswap(){
        swapping = true;
        _;
        swapping = false;
    }

    constructor () {
        // 0xED04a5791599907F6a8b903b63057E09Ba3281B4
        _uniswapV2Router = IUniswapV2Router02(0xED04a5791599907F6a8b903b63057E09Ba3281B4);
         
        // _uniswapV2Pair = IUniswapV2Factory(0xED04a5791599907F6a8b903b63057E09Ba3281B4)
        //     .createPair(msg.sender, _uniswapV2Router.WETH());
    }

    //request approval for spender and amount, owner is msg.sender
    function approve(address spender, uint amount) public{
        require(msg.sender!=address(0));
        require(spender!=address(0));
        require(spender!=msg.sender, "spender is owner");
        require(!getBlacklist(msg.sender), "owner blacklisted");
        require(!getBlacklist(spender), "spender blacklisted");
        allowances[msg.sender][spender] = amount;
        emit _approve(msg.sender, spender, amount);
    }

    function transfer(address from, address to, uint amount) public{
        require(balances[from] >= amount, "insufficient balance");
        require(from!=address(0));
        require(to!=address(0), "to blackhole");
        require(!getBlacklist(from), "sender blacklisted");
        require(!getBlacklist(to), "receipient blacklisted");
        balances[from] -= amount;
        balances[to] += amount;
        if(!fortax){
            tax(from, amount);
        }
        checkbalance();
        emit _transfer(from, to, amount);
    }

    //spender is msg.sender
    function transferFrom(address from, address to, uint amount) external{
        require(allowances[from][msg.sender] > amount, "not enough allowance");
        transfer(from, to, amount);
    }

    function burn(address account, uint amount) internal onlyOwner{
        //account balance > amount
        // call update
        require(account!=address(0));
        require(balances[account] > amount, "insufficient balance");
        balances[account] -= amount;
        balances[address(0)] += amount;
        _totalSupply -= amount;
        emit _burn(account,amount,_totalSupply);
    }

    function mint(address account, uint amount) internal onlyOwner {
        //account balance > amount
        // call update
        require(!getBlacklist(account));
        balances[account] += amount;
        _totalSupply += amount;
        emit _mint(account, amount, _totalSupply);
    }

    function tax(address from, uint amount) internal {
        uint taxperc;
        uint taxamount;
        require(from != address(0));
        require(!getBlacklist(from));
        if(getWhitelist(from)){
            taxperc = 5;
            taxamount = taxperc * amount/100;
        }else{
            taxperc = 15;
            taxamount = taxperc * amount/100;
        }
        fortax = true;
        transfer(from, address(this), taxamount);
        fortax = false;
    }

    function checkbalance() private{
        bool limit = _balanceOf(address(this)) > 100000;
        if(limit && !swapping){
            swapAndLiquify(100000);
        }
    }

    function swapAndLiquify(uint amount) private{
        uint half = amount/2;                               
        uint half2 = amount - half;

        uint initB = address(this).balance;

        //swap function, use half
        swapForETH(half);

        uint currentB = address(this).balance;
        uint wethamount = currentB - initB;

        //add liquity function use wethamount + half2
        addLiquidity(half2, wethamount);
        //call event
        emit AddLiquidity(half2, wethamount, block.timestamp);
    }

    function swapForETH(uint amount) private{
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = _uniswapV2Router.WETH();
        approve(address(_uniswapV2Router), amount);
        _uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            amount,
            0,
            path,
            address(this),
            block.timestamp
        );
    }

    function addLiquidity(uint tokenAmount, uint ethAmount) private{
        approve(address(_uniswapV2Router), tokenAmount);
        _uniswapV2Router.addLiquidityETH{value: ethAmount}(
            address(this),
            tokenAmount,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            owner(),/*0x0000000000000000000000000000000000000001,*/
            block.timestamp
        );
    }


     //init
    function name() external pure returns(string memory){
        return _name;
    }

    function symbol() external pure returns(string memory){
        return _symbol;
    }

    function decimals() external pure returns(uint){
        return _decimals;
    }

    function totalsupply() external view returns(uint){
        return _totalSupply;
    }

    //returns the balance of user
    function _balanceOf(address user) public view returns(uint){
        return balances[user];
    }

    // returns amount of allowance for spender
    function allowance(address owner, address spender) external view returns (uint){
        return allowances[owner][spender];
    }
}