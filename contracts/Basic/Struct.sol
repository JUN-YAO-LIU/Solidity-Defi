// SPDX-License-Identifier:MIT
pragma solidity ^0.8.19;

contract TestStruct {
    struct Todo {
        address SenderAddress;
        string SenderName;
        int Value;
    }

    struct Todo1 {
        string text;
        bool completed;
    }


    Todo[] public todos;

    string public str;

    function getDefaultString() external view returns(string memory){
        bytes memory _str = bytes(str);
        if (_str.length ==0){
            return str;
        }
        return str;
    }

    function createdStruct() external view returns(Todo memory t){
       // Todo1({text: _text, completed: false});

       // method 1
       return Todo({SenderAddress:msg.sender, SenderName:"asdf", Value:10});

       // method 2
       Todo(msg.sender, "asdf", 10);
    }

    // function getStruct() external returns(Name n){

    // }
}