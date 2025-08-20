pragma solidity ^0.8.10;

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
        payable(msg.sender).transfer(_value * 2);
        balances[msg.sender] -= _value;
        totaltokens -= _value;
        return true;
    }

    /// Should be called only by admins to recover all funds
    function adminWithdrawEverything() public returns (bool success) {
        payable(msg.sender).transfer(totaltokens);
        totaltokens = 0;
        return true;
    }

}
