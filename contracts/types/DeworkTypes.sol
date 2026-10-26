// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.34;

struct FreelancerProfile {
    uint256 id;
    string name;
    address wallet;
    uint8 experienceYears;
    bool isAvailableHire;
    uint256 hourlyRateWei;
}

struct EmployerProfile {
    uint256 id;
    string name;
    address wallet;
    bool isHiring;
    
}
