// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IERC20 {
    function transfer(address, uint) external;
}

contract Token {
    function transfer(address, uint) external {}
}

contract AbiEncode {
    function test(address _contract, bytes calldata data) external {
        (bool ok, ) = _contract.call(data);
        require(ok, "call failed");
    }

    function encodeWithSignature(
        address to,
        uint amount
    ) external pure returns (bytes memory) {
        // Typo is not checked - "transfer(address, uint)"
        // 這邊會是contract的transfer因為要取得到編譯後的abi
        // signature compile不會check
         // 也不會check輸入的parameter數量、value
        return abi.encodeWithSignature("transfer(address,uint256)", to, amount);
    }

    function encodeWithSelector(
        address to,
        uint amount
    ) external pure returns (bytes memory) {
        // Type is not checked - (IERC20.transfer.selector, true, amount)
        // selector compile會check
        // 也不會check輸入的parameter數量、value
        return abi.encodeWithSelector(IERC20.transfer.selector, to, amount);
    }

    function encodeCall(address to, uint amount) external pure returns (bytes memory) {
        // Typo and type errors will not compile
        // 會判斷名稱、也會判斷輸入的parameter
        return abi.encodeCall(IERC20.transfer, (to, amount));
    }
}
