// SPDX-License-Identifier:MIT
pragma solidity 0.8.20;

// Uniswap為範例，基本上跟使用別人的方法一樣，是使用address建造實例。
// 問題：不知道function一樣，但是interface 名稱不同可不可以？

interface ITestUpdateState{
    function mapState(address _a) external view returns(uint);

    function setMapState(uint _u) external;
}

// Uniswap example
interface UniswapV2Factory {
    function getPair(
        address tokenA,
        address tokenB
    ) external view returns (address pair);
}

interface UniswapV2Pair {
    function getReserves()
        external
        view
        returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
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

contract TestUpdateState is ITestUpdateState{
    mapping(address => uint) public mapState;
    constructor (){
        mapState[msg.sender] = 123;
    }

    function setMapState(uint _u) external {
        mapState[msg.sender] = _u;
    }
}

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

    function approve(address spender, uint amount) public returns (bool) {
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


contract TestApprove {
    ERC20 public token;

    constructor (){}

    function testApprove(address _a) external returns (bool) {
        token = ERC20(_a);
        token.approve(address(this),10);
        return true;
    }

    function testAllowance(address _a) external returns (uint) {
        token = ERC20(_a);
        uint t =  token.allowance(msg.sender,address(this));
        return t;
    }

    function testTransfer(address _a,address _b,uint _u) external{
        token = ERC20(_a);
        token.transfer(_b,_u);
    }

    function TestSetUpdateState(address _a,uint _u) external {
        ITestUpdateState state = ITestUpdateState(_a);
        state.setMapState(_u);
    }

    function abiSetState(address _a,uint _u) external {
        _a.call(
            abi.encodeWithSignature("setMapState(uint256)", _u)
        );
    }
}

contract UniswapExample {
    address private factory = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
    address private dai = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address private weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    function getTokenReserves() external view returns (uint, uint) {
        address pair = UniswapV2Factory(factory).getPair(dai, weth);
        (uint reserve0, uint reserve1, ) = UniswapV2Pair(pair).getReserves();
        return (reserve0, reserve1);
    }
}