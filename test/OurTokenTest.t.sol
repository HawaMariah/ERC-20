// SPDX-License-identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployOurToken} from "script/DeployOurToken.s.sol";
import {OurToken} from "src/OurToken.sol";

contract OurTokenTest is Test {
    OurToken public ourToken;
    DeployOurToken public deployer;
    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        vm.prank(address(msg.sender));
        ourToken.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public view {
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE);
    }

    function testAllowancesWork() public {
        uint256 initialAllowance = 1000;
        //bob approves Alice to spend token
        vm.prank(bob);
        ourToken.approve(alice, initialAllowance);

        uint256 transferAmoount = 500;
        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transferAmoount);

        assertEq(ourToken.balanceOf(alice), transferAmoount);
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmoount);
    }
}
