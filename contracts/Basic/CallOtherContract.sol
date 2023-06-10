// SPDX-License-Identifier:MIT
pragma solidity 0.8.19;

// 這是常見的方式
// 也可以用低等call的方式
// 隱藏合約也是這樣做

// method 1
contract methodWithAddress{
    constructor(){

    }

    function name() public view returns(string memory n){
        n = "JIm";
    }
}

// method 2
contract methodUseInstance{
    constructor(){

    }

    function instance() public view returns(string memory n){
        n = "Instance";
    }
}

contract CallOtherContract{

    string public name;

    string public method2;

    // method 1，利用產生實例的地址，創建變數直接用
    function callOther(address _contractAddress) public {
        methodWithAddress contract_a = methodWithAddress(_contractAddress);
        name = contract_a.name();
    }

    // method 2，直接導入實例直接用，但其實也是直接輸入address
    function useInstance(methodUseInstance i) public view returns(string memory){
       return i.instance();
    }

}