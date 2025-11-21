pragma solidity ^0.8.25;

abstract contract Game {
  uint256 public _internalCounter;

  function deposit() public virtual {
    _internalCounter += 1;
  }
}

contract EtherGame is Game {
  uint256 public _externalCounter;
  
  function deposit() public override {
    _externalCounter += 1;
    super.deposit();
  }

  function viewCounters() public view returns (uint256, uint256) {
    return (_internalCounter, _externalCounter);
  }
}
