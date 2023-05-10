// SPDX-License-Identifier:GPL-3.0
pragma solidity ^0.8.19;

// 查寫註解 工具

// error:是小寫
interface IERC20{
    // 1. abstract virtual 放哪？Ans:abstract function （還是錯）
    // 2. function 怎麼寫 
    // 3. 不能public 
    // 4. interface 裡面不會有狀態。
    // 5. are VIRTUAL BY DEFAULT
    // address a;

    // 確認花費的數量
    function approve(address spender, uint amount) external returns (bool);

    // 查詢核准的數量
    function allowance(address owner,address spender) external view returns (uint);

    // 轉帳 寫錯，需要每一個
    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool);

    function transfer(address spender,uint amount) external returns (bool);

    function balanceOf(address account) external view returns (uint);

    // string回傳需要用memory
    function symbol() external view returns (string memory);

    function name() external view returns (string memory);

    function totalSupply() external view returns (uint);

    // indexed 的位置。
    event Transfer(address indexed from,address indexed to, uint amount);
    event Approval(address indexed owner,address indexed spender, uint amount);
}

// 繼承interface每一個都需要實作
contract ERC20 is IERC20{
    mapping(address => mapping(address => uint)) public allowance;

    mapping(address => uint) public balanceOf;

    string public symbol;

    string public name;

    uint public totalSupply = 2**256 -1;

    constructor(
        string memory _symbol,
        string memory _name){
        symbol = _symbol;
        name = _name;
    }

    function approve(address spender, uint amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint amount
    ) external returns (bool) {
        allowance[from][msg.sender] -= amount;
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        emit Transfer(from, to, amount);
        return true;
    }

    function transfer(address recipient, uint amount) external returns (bool) {
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function mint(uint amount) internal{
        balanceOf[address(this)] -= amount;
        balanceOf[msg.sender] += amount;
        emit Transfer(address(this), msg.sender, amount);
    }
}


contract JimToken is ERC20{

    constructor(
        string memory _symbol,
        string memory _name) ERC20(_symbol,_name) {
    }

}