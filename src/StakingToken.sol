pragma solidity ^0.8.25;

contract StakingToken {
    uint256 totaltokens = 0;
    address admin = 0x2c1b3672E178457C7533a7f4aB491a920d15e444;

    constructor() {}

    mapping (address => uint256) balances;

    modifier onlyAdmin() {
      require(msg.sender == admin, "not an admin");
      _;
    }

    function deposit() public payable returns (bool success) {
        balances[msg.sender] += msg.value;
        totaltokens += msg.value;
        return true;
    }

    function withdraw(uint256 _value) public returns (bool success) {
        if (balances[msg.sender] < _value) return false;
        balances[msg.sender] -= _value;
        totaltokens -= _value;

        payable(msg.sender).transfer(_value);

        return true;
    }

    /// Should be called only by the admin, to recover all funds
    function adminWithdrawEverything() public returns (bool success) {
        totaltokens = 0;

        payable(msg.sender).transfer(totaltokens);

        return true;
    }

}
