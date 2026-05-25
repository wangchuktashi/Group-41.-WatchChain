// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Import Manufacturer contract
import "./Manufacturer.sol";

contract Retailer {

    // Connect to Manufacturer contract
    Manufacturer public manufacturer;

    // Set Manufacturer contract address
    constructor(address manufacturerAddress) {
        manufacturer = Manufacturer(manufacturerAddress);
    }

    // Retailer confirms receiving the watch
    function confirmRetailerReceipt(uint256 tokenId) external {
        require(manufacturer.isRetailer(msg.sender), "Only retailer");
        require(manufacturer.ownerOf(tokenId) == msg.sender, "Retailer not owner");

        manufacturer.updateStatus(tokenId, Manufacturer.WatchStatus.InRetail);
    }

    // Retailer sells watch to customer
    function sellToCustomer(uint256 tokenId, address customer) external {
        require(manufacturer.isRetailer(msg.sender), "Only retailer");
        require(manufacturer.ownerOf(tokenId) == msg.sender, "Retailer not owner");
        require(customer != address(0), "Invalid customer");

        manufacturer.transferByContract(
            tokenId,
            msg.sender,
            customer,
            Manufacturer.WatchStatus.Owned
        );
    }

    // Current owner transfers watch to another owner
    function transferToNewOwner(uint256 tokenId, address newOwner) external {
        require(manufacturer.ownerOf(tokenId) == msg.sender, "Not owner");
        require(newOwner != address(0), "Invalid owner");

        manufacturer.transferByContract(
            tokenId,
            msg.sender,
            newOwner,
            Manufacturer.WatchStatus.Owned
        );
    }
}