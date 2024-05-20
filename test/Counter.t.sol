// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Counter} from "../src/Counter.sol";

contract CounterTest is Test {
    Counter public counter;
    address public user;

    function setUp() public {
        counter = new Counter();
    }

    // test the time checking function
    function test_CheckTime() public {
        // should fail
        vm.expectRevert();
        counter.checkTime();

        // skip past the periodSec value of 10 seconds
        skip(11);

        // should pass
        counter.checkTime();
    }

    function test_Update() public {
        assert(counter.getCounter() == 0);

        // skip ahead so that sufficient time has passed for an update
        skip(11);
        counter.update();

        // check counter and lastUpdate were correctly updated
        assert(counter.getCounter() == 1);
        assert(counter.getLastUpdate() == block.timestamp);

        // fails, not enough time has passed
        vm.expectRevert();
        counter.update();

        // check counter value did not change because of checkTime failure causing a revert
        assert(counter.getCounter() == 1);
    }

    function test_UpdatePeriod() public {
        // will pass because the owner is calling it
        counter.updatePeriod(100);

        // fails to update because owner is required to update this field
        vm.startPrank(user, user);
        vm.expectRevert();
        counter.updatePeriod(100);
    }
}
