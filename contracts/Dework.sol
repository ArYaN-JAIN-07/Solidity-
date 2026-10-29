// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.34;
import {FreelancerProfile, EmployerProfile, CreateJobListingInput, JobListing} from "./types/DeworkTypes.sol";

contract Dework {
    uint256 public constant LATE_PENALITY_BPS_PER_DAY = 500; //500/10000 = 5%
    uint256 public constant BPS_DENOMINATOR = 10000; //100%

    uint256 connectFee;
    address public owner;

    FreelancerProfile[] public freelancerProfiles;
    EmployerProfile[] public employerProfiles;

    mapping(uint256 => address) public freelancerIdToAddress;
    mapping(uint256 => address) public employerIdToAddress;
    mapping(uint256 => uint256) public employerBalance;

    event FreelancerProfileRegistered(uint256 freelancerId, address caller);
    event EmployerProfileRegistered(uint256 employerId, address caller);
    
    error Dework_IncorrectJobCreationFee(uint256 expectedFee, uint256 actualFee);
   

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

    function registerEmployerProfile(string calldata employerName) external {
    uint256 employerId = employerProfiles.length;

    employerProfiles.push();

    EmployerProfile storage employerProfile = employerProfiles[employerId];

    employerProfile.id = employerId;
    employerProfile.name = employerName;
    employerProfile.isHiring = false;
    employerProfile.wallet = msg.sender;

    employerIdToAddress[employerId] = msg.sender;

    emit EmployerProfileRegistered(employerId, msg.sender);
}

    function getNumberOfCreatedJobList(uint256 employerId) public view returns (uint256) {
        return employerProfiles[employerId].jobListing.length;
    }

    function _getEmployerProfile(uint256 employerId) internal view returns (EmployerProfile storage) {
        return employerProfiles[employerId];
    }

    function createJobListing(uint256 employerId, CreateJobListingInput calldata jobListingInput)
        external
        payable
    {
        uint256 fixedPriceForJob = jobListingInput.fixedPriceInWei;

        if (msg.value != fixedPriceForJob) {
            revert Dework_IncorrectJobCreationFee(fixedPriceForJob, msg.value);
        }

        EmployerProfile storage employerProfile = _getEmployerProfile(employerId);
        uint256 jobId = getNumberOfCreatedJobList(employerId);

        JobListing memory newJob = JobListing({
            id: jobId,
            title: jobListingInput.title,
            description: jobListingInput.description,
            deadlineTimestamp: block.timestamp + jobListingInput.deadlineTimestamp,
            isOpen: true,
            fixedPriceInWei: jobListingInput.fixedPriceInWei,
            hiredFreelancerId: 0,
            hasHiredFreelancer: false,
            isPaid: false
        });
        
        employerProfile.jobListing.push(newJob);
        //    employerProfiles[employerId].jobListing.push(newJob);
    }


    

  

   


   

    
}