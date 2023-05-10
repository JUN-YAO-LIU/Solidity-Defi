// SPDX-License-Identifier:GPL-3.0
pragma solidity ^0.8.19;

interface IERC20{
   function transfer(address sender,uint amount) external;
}

// library safeMath是library裏面。 
library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}

// 應該是時段放滿才能，領錢。
contract Staking{

    address public owner;

    // using for的用法
    using SafeMath for uint;

    // 不能是字串，是40個字
    address private tokenAddr = 0x1111111111111111111111111111111111111110;
    IERC20 immutable stackingToken;

    // type 有小數？
    uint duration = 3;

    // 8 / 100
    uint rate = 8;

    // struct取值、
    // struct StakingData{
    //     uint startAt;
    //     uint endAt;
    //     uint amount;
    //     uint reward;
    // }

    // 第幾個質押的，這個地址質押多少數量。
    mapping(address => uint[]) balanceOf;

    mapping(address => uint) rewards;

    constructor (){
        stackingToken = IERC20(tokenAddr);
    }

    // 存入token後就開始（活存）
    function deposite() public {
    }

    function getReward() public view returns(uint){}

    function withdrawl() public {}
}