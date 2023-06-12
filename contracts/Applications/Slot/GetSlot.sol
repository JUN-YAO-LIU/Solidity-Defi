// SPDX-License-Identifier:MIT
pragma solidity 0.8.19;


contract SlotTest{

    struct StructSlot{
        address Value;
    }

    StructSlot public structSlot;

    constructor(){
        structSlot.Value = msg.sender;
    }

    function getStructSlot() public pure returns(bytes32 r){
        assembly{
          r := structSlot.slot
        }
    }

}