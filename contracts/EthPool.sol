// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

import "./IERC20.sol";
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";


contract EthPool is AccessControlEnumerable {
    

  
    bytes32 public constant DIBURSER_ROLE = keccak256("DIBURSER_ROLE");

    
    mapping(address => uint) balances;
    address[] contributors;
    
    address xlyToken;
    uint totalBalance;


    constructor (address _xly) {

        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _setupRole(DIBURSER_ROLE, _msgSender());
        xlyToken =  _xly;
        
    }

    event LogDepositReceived(address _address, uint _amount);
    event NewDeposit(address _address, uint _amount, uint _totalSupply);
    
    
    function deposit() payable public notAdmin {
        balances[msg.sender] = balances[msg.sender] + msg.value;
        totalBalance = totalBalance + msg.value;
        contributors.push(msg.sender);
        IERC20(xlyToken).mint(msg.sender,msg.value);
        emit NewDeposit(msg.sender,msg.value,totalBalance);
         
    }


    function diburse() payable public {
        require(hasRole(DIBURSER_ROLE,msg.sender),"Not enough privileges.");
        uint benefitPerToken =  msg.value / totalBalance ;
        for(uint i=0;i<contributors.length;i++){
            address contributor = contributors[i];

             IERC20(xlyToken).transfer(contributor,balances[contributor]*benefitPerToken);
        }

           
    }

    //fallback
    fallback() external payable {
        require(msg.data.length == 0);
        emit LogDepositReceived(msg.sender, msg.value);
    }
    receive() external payable {
       
        emit LogDepositReceived(msg.sender,msg.value); }
    

    modifier notAdmin {
        require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()) == false, "An Admin cannot execute this function.");
        require(hasRole(DIBURSER_ROLE, _msgSender())== false, "A Diburser cannot execute this function.");
        _;
    }
}

