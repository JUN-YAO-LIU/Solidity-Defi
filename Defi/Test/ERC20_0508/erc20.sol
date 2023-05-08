// SPDX-License-Identifier:GPL-3.0
pragma solidity ^0.8.19;

// 查寫註解 工具

// error:是小寫
interface IERC20{

    // 1. abstract virtual 放哪？ 2. function 怎麼寫
    function approve(address spender, uint amount)  external  returns (bool);
}


contract ERC20 is IERC20{

    function approve(address spender, uint amount) external returns (bool) {
        // allowance[msg.sender][spender] = amount;
        // emit Approval(msg.sender, spender, amount);
        return true;
    }
}