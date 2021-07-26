pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/math/SafeMath.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20Detailed.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20Mintable.sol";


contract ERC20Interface {
    function totalSupply() external view returns (uint);
    function balanceOf(address tokenOwner) external view returns (uint balance);
    function transfer(address to, uint tokens) external returns (bool success);

    function allowance(address tokenOwner, address spender) external view returns (uint remaining);
    function approve(address spender, uint tokens) external returns (bool success);
    function transferFrom(address from, address to, uint tokens) external returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract initialCoinOffering is ERC20Interface {
    

    // uint fakenow = now;    
    string public name;
    string public symbol;
    uint decimals;
    uint public bonusEnds;
    uint public icoEnds;
    uint public icoStarts;
    uint public allContributers;
    uint public allTokens;
    address payable admin;
    mapping (address => uint) public balances;
    mapping(address => mapping(address => uint)) allowed;
    
    // function fastforward() public { 
    //     fakenow += 29 days;
    // }        
    
    function ICO () public {
        name = "PlaneSimpleCoin";
        decimals = 18;
        symbol = "PLNS";
        bonusEnds = now + 2 weeks;
        icoEnds = now + 4 weeks;
        icoStarts = now;
        // allTokens = 100000000000000000000 * 100;   // equals 100 ether * 100 PLNS  
        allTokens = 100;
        admin = (msg.sender);
        balances[msg.sender] = allTokens;        
        // balances[address(this)] = allTokens;        
    }
    
    function buyTokens() public payable {
        uint tokens;
        // tokens = msg.value * 100; // 100 PLNS token == 1 ether
        tokens = msg.value;
        balances[msg.sender] = balances[msg.sender] + tokens;
        allTokens = allTokens + tokens;
    }
    
    
    function myBalance () public view returns (uint) {
        return (balances[msg.sender]);
    }
    
    function myAddress () public view returns (address) {
        address myAdr = msg.sender;
        return myAdr;
    }    
    
    // At end of ICO, send all the ETHER from the contract address to the admin's wallet
    // IF the ICO ends, you as the admin can call the following function, then you have access to all the money generated in the ICO
    function endSale() public {
        require(msg.sender == admin, "You're not the contract owner, fool");
        admin.transfer(address(this).balance);
    }
    
    
}