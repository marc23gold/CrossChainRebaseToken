//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title RebaseToken
 * @author BT
 * @dev Implementation of the RebaseToken
 * @notice This is a cross-chain rebase token that incentivizes users to deposit into a vault
 * @notice The interest rate can only decrease
 * @notice Each user will have their own interest rate that is the global interest rate determined at the time of deposit
 */
contract RebaseToken is ERC20 {

    error RebaseToken__InterestRateDecreaseError(uint256 newInterestRate, uint256 oldInterestRate);

    event InterestRateSet(uint256 newInterestRate);

    mapping (address user => uint256 interestRate) private s_userInterestRate;

    uint256 private s_interestRate = 5e10;

    constructor() ERC20("Rebase", "RBS") {}

    /**
     * @notice Sets the interest rate 
     * @dev The interest rate can only decrease
     * @param _newInterestRate The new interest rate
     */
    function setInterestRate(uint256 _newInterestRate) external {
        //set the interest rate
        if( _newInterestRate < s_interestRate) {
            revert RebaseToken__InterestRateDecreaseError(_newInterestRate, s_interestRate);
        }
        s_interestRate = _newInterestRate;
        emit InterestRateSet(_newInterestRate);
    }

    function mintRebase(uint256 _amount, address _to) external{
        _mintAccruedInterest( _to);
        s_userInterestRate[msg.sender] = s_interestRate;
         _mint(_to, _amount);

    }

    function burnRebase(uint256 _amount, address _from) external{

    }

    function _mintAccruedInterest( address _to) internal{
        
    }
    /**
     * @notice Gets the global interest rate
     * @return The global interest rate
     */
    function getUserInterestRate(address _user) external view returns(uint256){
        return s_userInterestRate[_user];
    }   

}