pragma solidity ^0.8.25;

contract StakingToken {
    uint256 totaltokens = 0;

    constructor() {}

    mapping (address => uint256) balances;

    function deposit() public payable returns (bool success) {
        balances[msg.sender] += msg.value;
        totaltokens += msg.value;
        return true;
    }

    function withdraw(uint256 _value) public returns (bool success) {
        if (balances[msg.sender] < _value) return false;
        (bool success_, ) = msg.sender.call{value: _value}("");
        require(success_, "transaction failed");

        balances[msg.sender] -= _value;
        totaltokens -= _value;
        return true;
    }

    /// Should be called only by admins to recover all funds
    function adminWithdrawEverything() public returns (bool success) {
        (bool success_, ) = msg.sender.call{value: totaltokens}("");
        require(success_, "transaction failed");
        totaltokens = 0;
        return true;
    }

}
