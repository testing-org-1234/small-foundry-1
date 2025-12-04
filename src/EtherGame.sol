pragma solidity ^0.8.25;

abstract contract MyContractThatIsVeryAbstract {
  uint public sum = 53;

  constructor () {
    sum = 44;
  }


  function increase() public {
    sum = sum + 1;
  }
}

interface ICounter {
    function count() external view returns (uint256);
    function increment() external;
}

contract EtherGame {
    uint public targetAmount = 10 ether;
    address public winner;

    constructor() {
      targetAmount = 9 ether;
    }

    modifier checkIsWinner() {
      require(msg.sender == winner, "Is not winner");
      _;
    }

    function deposit() public payable {
        require(msg.value == 2 ether, "You can only send 2 Ether");

        uint balance = address(this).balance;
        require(balance <= targetAmount, "Game is over");

        if (balance == targetAmount) {
            winner = msg.sender;
        }
    }

    function claimReward() public checkIsWinner {
        require(msg.sender == winner, "Not winner");

        (bool sent, ) = msg.sender.call{value: address(this).balance}("");
        require(sent, "Failed to send Ether");
    }

    function () payable {
      targetAmount = targetAmount + 1 ether;
    }
}
