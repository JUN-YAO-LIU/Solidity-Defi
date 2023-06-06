// SPDX-License-Identifier:MIT
pragma solidity 0.8.19;

contract TestMath{

    string public str  = "123";
    uint8 public testUnchecked  =255;

    function UncheckedMath() external returns(uint8){

        unchecked{
            testUnchecked++;
        }

        return testUnchecked;
    }
}