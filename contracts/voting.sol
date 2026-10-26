// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Voting {

    address public owner;

    uint public XVotes = 0;
    uint public YVotes = 0;

    constructor() {
        owner = msg.sender;
    }

    function voteX() public {
        XVotes++;
    }

    function voteY() public {
        YVotes++;
    }

    function getXVotes() public view returns (uint) {
        return XVotes;
    }

    function getYVotes() public view returns (uint) {
        return YVotes;
    }

    function resetVotes() public {
        require(msg.sender == owner, "Only owner can reset");
        XVotes = 0;
        YVotes = 0;
    }
}