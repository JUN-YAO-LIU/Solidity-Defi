// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract FixedDeposit{

    mapping(address => Txn[]) txnRecords;

    address public owner;

    // days 至少要存滿一天
    uint public period;

    uint public apr;

    uint public limitAmount;

    // 當下這筆定存的交易資料，apr之類的可能會更改
    struct Txn{
        // NSK 紀錄原生
        uint amount;
        uint apr;
        uint startAt;
        uint period;
    }

    modifier _onlyowner{
        require(owner == msg.sender,"Don't have Authorization");
        _;
    }

    event Deposit(address indexed account,uint indexed txnId);

    constructor() payable {
        owner = msg.sender;
        apr = 8;
        limitAmount = 0.00001 ether;
        period = 10;
    }


    function getOrder(uint id) external view returns(Txn memory){
        return txnRecords[msg.sender][id];
    }

    function getAllOrder() external pure{

    }


    function deposit() external payable{
        require(limitAmount <= msg.value,"deposit is not enough.");
        txnRecords[msg.sender].push(
            Txn({
                amount: msg.value,
                apr: apr,
                startAt: block.timestamp,
                period: period
            })
        );

        uint id = txnRecords[msg.sender].length - 1;
        emit Deposit(msg.sender,id);
    }

    function withdral() external pure{

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