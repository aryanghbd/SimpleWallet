pragma solidity 0.8.1;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
//Useful library for ownership functionality

contract Allowance is Ownable {

    event AllowanceChanged(address indexed _forWho, address indexed _byWhom, uint _oldAmount, uint _newAmount);
    //Event for changing allowance at a given time.
    mapping(address => uint) public allowance;
    //Map an address to its allowance
    
    
    //Function: isOwner()
    //          Sanity check to verify whether or not the current user of the wallet has administrative rights.
    //          Returns: Boolean - TRUE if address is owner, FALSE otherwise.
    
    function isOwner() internal view returns(bool) {
        return owner() == msg.sender;
    }
    
    //Function: setAllowance()
    //Parameters: -address _who - Address who's allowance is to be changed
    //            -uint _amount - The amount to be set as allownace as a uint (note 1 ETH is 10e18 wei)
    //
    //            Administrator function that sets the allowance for each low-level user. 
    
    function setAllowance(address _who, uint _amount) public onlyOwner {
        emit AllowanceChanged(_who, msg.sender, allowance[_who], _amount);
        allowance[_who] = _amount;
    }
    
    //Modifier: ownerOrAllowed()
    //Parameter: uint _amount - The amount to be verified
    //
    //          Checks whether or not a given amount exceeds the allowance (if any) of a user, if the user is the owner, this check passes.
    modifier ownerOrAllowed(uint _amount) {
        require(isOwner() || allowance[msg.sender] >= _amount, "You are not allowed!");
        _;
    }
    
    //Function: reduceAllowance()
    //Parameters: -address _who - Address who's allowance is to be changed
    //            -uint _amount - The amount to be reduced as allownace as a uint (note 1 ETH is 10e18 wei)
    //
    //            Administrator function that reduces the allowance for each low-level user. 
    
    function reduceAllowance(address _who, uint _amount) internal ownerOrAllowed(_amount) {
        emit AllowanceChanged(_who, msg.sender, allowance[_who], allowance[_who] - _amount);
        allowance[_who] -= _amount;
    }

}
