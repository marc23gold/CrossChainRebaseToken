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

    uint256 private s_interestRate = 5e10;

    constructor() ERC20("Rebase", "RBS") {}

    function setInterestRate(uint256 _newInterestRate) external {
        //set the interest rate
        if( _newInterestRate < s_interestRate) {
            revert RebaseToken__InterestRateDecreaseError(_newInterestRate, s_interestRate);
        }
        s_interestRate = _newInterestRate;
    }

}