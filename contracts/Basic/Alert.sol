// SPDX-License-Identifier:MIT
pragma solidity 0.8.20;

contract TestAlert{

    function Assert() public pure {
        assert(false);
    }

    function Require() public pure {
        require(false);
    }

    function Requirev2() public pure {
        require(false,"ERROR Test");
    }

}