// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// 呼叫不存在的function
// 傳送msg.value 但沒有receive
// 傳送msg.value 但有msg.data
// remix 使用calldata就會傳送msg.data
// 補充 calldata主要是傳遞外部的資料

contract Fallback {
    event Log(string func, uint gas);
    bytes public data;

    // Fallback function must be declared as external.
    fallback() external payable {
        // send / transfer (forwards 2300 gas to this fallback function)
        // call (forwards all of the gas)
        data = msg.data;
        emit Log("fallback", gasleft());
    }

    // Receive is a variant of fallback that is triggered when msg.data is empty
    receive() external payable {
        emit Log("receive", gasleft());
    }

    // Helper function to check the balance of this contract
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

contract SendToFallback {
    function transferToFallback(address payable _to) public payable {
        _to.transfer(msg.value);
    }

    function callFallback(address payable _to) public payable {
        (bool sent, ) = _to.call{value: msg.value}("");
        require(sent, "Failed to send Ether");
    }
}
