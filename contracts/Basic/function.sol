// SPDX-License-Identifier:MIT
pragma  solidity ^0.8.19;


contract TestFunctionV2 {

    uint public u;

    function SetValuev2(uint n) external {
        u += n;
    }

    function FunGetUnitv2(uint n) external payable returns (uint n1) {
        n1 = n + 123;
    }
}

contract TestFunctionV1 {

    TestFunctionV2 v2;
    constructor(address _v2Address)payable{
        v2 = TestFunctionV2(_v2Address);
    }

    function GetFunV2(uint eth) external returns(uint){
        // 只能用value，匯入ether
        v2.FunGetUnitv2{value:eth}(eth);
        return eth;
    }

    function SetValuev2(uint a) external {
        v2.SetValuev2(a);
    }
   
}