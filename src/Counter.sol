// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Counter {
    uint256 public periodSecs;
    uint256 public lastUpdate;
    uint256 public counter;
    address public owner;

    // init with default values
    constructor() {
        lastUpdate = block.timestamp;
        periodSecs = 10;
        owner = msg.sender; // set owner to contract deployer
    }

    // assert that sufficient time has passed between the last update timestamp and the current block timestamp
    function checkTime() public view {
        uint256 delta = block.timestamp - lastUpdate;
        require(delta >= periodSecs);
    }

    // will revert if caller is not contract owner
    function checkOwner() public view {
        require(msg.sender == owner);
    }

    // if its been sufficiently long enough since the previous update, increment the counter by 1
    function update() external {
        // check time to make sure its been long enough
        checkTime();

        // do the application action
        counter++;

        // set the lastUpdate to the timestamp
        lastUpdate = block.timestamp;
    }

    // change the periodSecs variable
    function updatePeriod(uint256 newPeriodSecs) external {
        // only allow the owner to change the period
        checkOwner();
        periodSecs = newPeriodSecs;
    }

    function getCounter() public view returns (uint256) {
        return counter;
    }

    function getLastUpdate() public view returns (uint256) {
        return lastUpdate;
    }
}
