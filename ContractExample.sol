// *************************************************************처음 배우는 블록체인
//p246 /Users/malcogene/myproject/metacoin/contracts
//### Migrations.sol
pragma solidity ^0.4.2;

contract Migrations {
  address public owner;
  uint public last_completed_migration;

  modifier restricted() {
    if (msg.sender == owner) _;
  }

  constructor() public {
    owner = msg.sender;
  }

  function setCompleted(uint completed) public restricted {
    last_completed_migration = completed;
  }

  function upgrade(address new_address) public restricted {
    Migrations upgraded = Migrations(new_address);
    upgraded.setCompleted(last_completed_migration);
  }
}

//### ConvertLib.sol
pragma solidity ^0.4.4;
library ConvertLib{
	function convert(uint amount,uint conversionRate) public pure returns (uint convertedAmount)
	{
		return amount * conversionRate;
	}
}
//library 로 실행하면 해당 함수를 호출한 계약에서 실행한다는 점이 contract와 다르다. library로 선언하면 라이브러리에서
//함수를 정의했어도 호출한 계약에서 상태 변수를 참조할 수 있다.


###MetaCoin.sol
pragma solidity ^0.4.18;

import "./ConvertLib.sol";

// This is just a simple example of a coin-like contract.
// It is not standards compatible and cannot be expected to talk to other
// coin/token contracts. If you want to create a standards-compliant
// token, see: https://github.com/ConsenSys/Tokens. Cheers!

contract MetaCoin {
        mapping (address => uint) balances; //키는 address(사용자주소) 값은 uint 메타코인 소유량 관리

        event Transfer(address indexed _from, address indexed _to, uint256 _value);

        constructor() public {
                balances[tx.origin] = 10000;
        }
//생성자 함수. 계약을 초기화할 때 실행하는 함수 mapping에서 정의한 [tx.origin]에 무조건 10000 메타코인을 얻는다
        function sendCoin(address receiver, uint amount) public returns(bool sufficient) {
                if (balances[msg.sender] < amount) return false;
                balances[msg.sender] -= amount;
                balances[receiver] += amount;
                emit Transfer(msg.sender, receiver, amount);
                return true;
        }
//
        function getBalanceInEth(address addr) public view returns(uint){
                return ConvertLib.convert(getBalance(addr),2);
        }
// 주소타입 addr  ConvertLib의 convert 메서드를 실행해 getBalance(addr)함수를 호출한다.
        function getBalance(address addr) public view returns(uint) {
                return balances[addr];
        }
}

//blockchain_book/08/dapps-token/contracts/DappsToken.sol
pragma solidity ^0.4.24; // ①

import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol"; // ②

contract DappsToken is StandardToken { // ③ contract <계약 이름> is <상속하는 계약 이름>
    string public name = "DappsToken"; // 토큰 이름 설정
    string public symbol = "DTKN"; // 토큰을 화폐 단위로 나타낼 때의 기호 설정
    uint public decimals = 18; // 토큰에서 허용할 소수점 자릿수 설정

    // ④
    constructor(uint initialSupply) public {
        totalSupply_ = initialSupply;
        balances[msg.sender] = initialSupply;
    }
}
// blockchain_book/08/dapps-token/migrations/2_deploy_dapps_token.js
var DappsToken = artifacts.require("./DappsToken.sol"); // ①

// ②
module.exports = function(deployer) {
    var initialSupply = 1000e18;
    deployer.deploy(DappsToken, initialSupply, {
        gas: 2000000
    });
}
