// SPDX-License-Identifier:MIT
pragma solidity ^0.8.19;


contract TestVariable{

    string public str = "a";

    string[] public strArr; 

    // string
    function getDefaultString() external view returns(string memory){
        bytes memory _str = bytes(str);
        if (_str.length ==0){
            return str;
        }
        return "str";
    }

    // Array
    function getDefaultArray() external view returns(uint){
        if (strArr.length ==0){
            return 0;
        }
        return strArr.length;
    }
}