// SPDX-License-Identifier:GPL-3.0
pragma solidity ^0.8.19;

interface IERC20{

    function totalSupplier() external view returns(uint);

    function balanceOf(address account) external view returns(uint);

    function allowance(address owner,address spender) external view returns(uint);

    // fail : function approve(address spender, uint amount) external returns (bool);
    function approve(address owner,address spender,uint amount) external returns(bool);

    function transferFrom(address from,address to,uint amount) external returns(bool);

    function transfer(address to,uint amount) external returns(bool);
    
    // indexed 要放在type後面
    event Approval(address indexed owner, address indexed spender, uint amount);
    event Transfer(address indexed from, address indexed to, uint amount);

}

contract ERC20 is IERC20{

    uint public totalSupplier = 2**256 - 1;
    mapping(address => uint) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;
    string public name;
    string public symbol;
    // fail 缺 decimal，uint8 public decimals = 18;

    constructor(string memory _name,string memory _symbol){
        name = _name;
        symbol = _symbol;
    }

    // 複寫可以改修飾詞 view pure這種。
    function approve(address owner,address spender,uint amount) public returns(bool){
        // fail : allowance[msg.sender][spender] = amount;
        require(amount >0,"must be than zero.");
        allowance[owner][spender] += amount;
        return true;
    }

    // overriding function， 如果是實作的function 就算是覆寫，如果型態跟interface的不同就會出現錯誤
    function transferFrom(address from,address to,uint amount) external returns(bool){
        allowance[from][msg.sender] -= amount;
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        return true;
    }

    function transfer(address to,uint amount) external returns(bool){
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        return true;
    }
}


contract JimToken{
}