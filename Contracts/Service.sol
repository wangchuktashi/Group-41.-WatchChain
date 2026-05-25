// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Import Manufacturer contract
import "./Manufacturer.sol";

contract Service {

    // Connect to Manufacturer contract
    Manufacturer public manufacturer;

    // Store service information
    struct ServiceDetails {
        string reason;
        string details;
        address serviceCentre;
        uint256 servicedAt;
    }

    // Store service history for each watch
    mapping(uint256 => ServiceDetails[]) public serviceHistory;

    // Set Manufacturer contract address
    constructor(address manufacturerAddress) {
        manufacturer = Manufacturer(manufacturerAddress);
    }

    // Mark watch as in service
    function markInService(uint256 tokenId) external {
        require(manufacturer.isServiceCentre(msg.sender), "Only service centre");

        manufacturer.updateStatus(tokenId, Manufacturer.WatchStatus.InService);
    }

    // Add service details to watch history
    function addServiceDetails(
        uint256 tokenId,
        string memory reason,
        string memory details
    ) external {
        require(manufacturer.isServiceCentre(msg.sender), "Only service centre");

        serviceHistory[tokenId].push(
            ServiceDetails({
                reason: reason,
                details: details,
                serviceCentre: msg.sender,
                servicedAt: block.timestamp
            })
        );

        manufacturer.updateStatus(tokenId, Manufacturer.WatchStatus.Serviced);
    }

    // Return watch back to owner
    function returnToOwner(uint256 tokenId, address ownerAddress) external {
        require(manufacturer.isServiceCentre(msg.sender), "Only service centre");
        require(ownerAddress != address(0), "Invalid owner");

        manufacturer.transferByContract(
            tokenId,
            manufacturer.ownerOf(tokenId),
            ownerAddress,
            Manufacturer.WatchStatus.Owned
        );
    }

    // Get total service records for a watch
    function getServiceRecordCount(uint256 tokenId) external view returns (uint256) {
        return serviceHistory[tokenId].length;
    }

    // Get service details using index
    function getServiceDetails(
        uint256 tokenId,
        uint256 index
    )
        external
        view
        returns (
            string memory reason,
            string memory details,
            address serviceCentre,
            uint256 servicedAt
        )
    {
        require(index < serviceHistory[tokenId].length, "Invalid index");

        ServiceDetails memory record = serviceHistory[tokenId][index];

        return (
            record.reason,
            record.details,
            record.serviceCentre,
            record.servicedAt
        );
    }
}