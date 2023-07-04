// SPDX-License-Identifier:MIT
pragma solidity ^0.8.20;

// haven't contructor
contract CreatedContractNotConstructor{
  

}

// have contructor
contract CreatedContractHaveConstructor{
    constructor(){
        
    }
}

// token 繼承
contract Giloo{

    uint8 testUint8;
    uint256 testUint256;

    int8 testInt8;
    int256 testInt256;

    bool testBool;


    function getTypeInt() external pure{
        type(int);
    }

}

library TypeConvert{
    // function stringToUint(string s) public returns (uint) {
    //         bytes memory b = bytes(s);
    //         uint result = 0;
    //         for (uint i = 0; i < b.length; i++) { // c = b[i] was not needed
    //             if (b[i] >= 48 && b[i] <= 57) {
    //                 result = result * 10 + (uint(b[i]) - 48); // bytes and int are not compatible with the operator -.
    //             }
    //         }
    //         return result; // this was missing
    //     }

    // function uintToString(uint v) public returns (string) {
    //     uint maxlength = 100;
    //     bytes memory reversed = new bytes(maxlength);
    //     uint i = 0;
    //     while (v != 0) {
    //         uint remainder = v % 10;
    //         v = v / 10;
    //         reversed[i++] = byte(48 + remainder);
    //     }
    //     bytes memory s = new bytes(i); // i + 1 is inefficient
    //     for (uint j = 0; j < i; j++) {
    //         s[j] = reversed[i - j - 1]; // to avoid the off-by-one error
    //     }
    //     string memory str = string(s);  // memory isn't implicitly convertible to storage
    //     return str;
    // }
}
