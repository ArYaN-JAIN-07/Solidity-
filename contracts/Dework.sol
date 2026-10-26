// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.34;
import {FreelancerProfile, EmployerProfile , CreateJobListingInput} from "./types/DeworkTypes.sol";

contract Dework {
   

    uint256 connectFee;
    address public owner;

    FreelancerProfile[] public freelancerProfiles;
    EmployerProfile[] public employerProfiles;

    mapping(uint256 => address) public freelancerIdToAddress;
    mapping(uint256 => address) public employerIdToAddress;
   

    event FreelancerProfileRegistered(uint256 freelancerId, address caller);

    error Dework_IncorrectJobCreationFee(uint256 expectedFee , uint256 actualFee);
    


    constructor(address _initialOwner) {
        owner = _initialOwner;
    }



    function getFreelancerProfile(uint256 freelancerId) public view returns (FreelancerProfile memory) {
        return freelancerProfiles[freelancerId];
    }

    function getNumberOfRegisteredFreelancers() public view returns (uint256) {
        return freelancerProfiles.length;
    }

    function registerFreelancerProfile(string calldata name, uint8 experienceYears, uint256 hourlyRateWei) external {
        uint256 freelancerId = getNumberOfRegisteredFreelancers();

        FreelancerProfile memory freelancerProfile = FreelancerProfile({
            id: freelancerId,
            name: name,
            wallet: msg.sender,
            experienceYears: experienceYears,
            isAvailableHire: true,
            hourlyRateWei: hourlyRateWei
        });
        freelancerProfiles.push(freelancerProfile);
        freelancerIdToAddress[freelancerId] = msg.sender;

        emit FreelancerProfileRegistered(freelancerId, msg.sender);
    }

    function getNumberOfRegisteredEmployers() public view returns (uint256) {
        return employerProfiles.length;
    }

    function registerEmployerProfile(string calldata employerName) public {
        uint256 employerId = getNumberOfRegisteredEmployers();
        EmployerProfile memory employerProfile = EmployerProfile({
            id: employerId,
            name: employerName, 
            isHiring: false, 
            wallet: msg.sender
        });
        employerProfiles.push(employerProfile);
        employerIdToAddress[employerId] = msg.sender;
        emit FreelancerProfileRegistered(employerId, msg.sender);
    }

    function createJobListing(
        uint256 employerId , 
        CreateJobListingInput calldata jobListingInput
         ) external payable  {

            if(msg.value != jobListingInput.fixedPriceInWei ) {

                revert Dework_IncorrectJobCreationFee(jobListingInput.fixedPriceInWei , msg.value);
            }



        }


   
}