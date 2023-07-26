// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract SendNSK{

    address public owner;

    modifier _onlyowner{
        require(owner == msg.sender,"Don't have Authorization");
        _;
    }

    mapping(address => uint) balanceOf;

    constructor(){
        owner = msg.sender;
    }

    

}