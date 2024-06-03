// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CharityDonation {
    struct Charity {
        string name;
        string description;
        address payable wallet;
        uint256 totalDonations;
    }

    uint256 public charityCount;
    mapping(uint256 => Charity) public charities;

    event CharityCreated(uint256 charityId, string name, string description, address wallet);
    event DonationReceived(uint256 charityId, address donor, uint256 amount);

    function createCharity(string memory name, string memory description, address payable wallet) external {
        charityCount++;
        charities[charityCount] = Charity(name, description, wallet, 0);
        emit CharityCreated(charityCount, name, description, wallet);
    }

    function donate(uint256 charityId) external payable {
        Charity storage charity = charities[charityId];
        require(charity.wallet != address(0), "Invalid charity");

        charity.totalDonations += msg.value;
        charity.wallet.transfer(msg.value);
        emit DonationReceived(charityId, msg.sender, msg.value);
    }

    function getCharity(uint256 charityId) external view returns (string memory name, string memory description, address wallet, uint256 totalDonations) {
        Charity storage charity = charities[charityId];
        return (charity.name, charity.description, charity.wallet, charity.totalDonations);
    }
}
