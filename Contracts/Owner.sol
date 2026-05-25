// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Import Manufacturer contract
import "./Manufacturer.sol";

contract Owner {

    // Connect to Manufacturer contract
    Manufacturer public manufacturer;

    // Set Manufacturer contract address
    constructor(address manufacturerAddress) {
        manufacturer = Manufacturer(manufacturerAddress);
    }

    // Verify if caller owns the watch
    function verifyOwner(uint256 tokenId) external view returns (bool) {
        return manufacturer.ownerOf(tokenId) == msg.sender;
    }

    // Get current watch owner
    function checkOwner(uint256 tokenId) external view returns (address) {
        return manufacturer.ownerOf(tokenId);
    }

    // Verify watch details and status
    function verifyWatch(uint256 tokenId)
        external
        view
        returns (
            string memory serialNumber,
            string memory model,
            string memory status
        )
    {
        (
            string memory serial,
            string memory watchModel,
            ,
            ,
            string memory watchStatus,
            
        ) = manufacturer.getWatchInfo(tokenId);

        return (serial, watchModel, watchStatus);
    }

    // Check service record using index
    function checkServiceRecord(uint256 tokenId, uint256 index)
        external
        view
        returns (
            uint256 serviceDate,
            string memory reason,
            address serviceCentre
        )
    {
        return manufacturer.getServiceRecord(tokenId, index);
    }

}