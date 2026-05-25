// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Import ERC721 token 
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Manufacturer is ERC721 {
    // Watch status options
    enum WatchStatus {
        Registered,
        InRetail,
        Owned,
        InService,
        Serviced,
        Stolen
    }

    // Main watch details
    struct WatchDetails {
        string serialNumber;
        string model;
        string description;
        uint256 mintedAt;
        WatchStatus status;
    }

    // Service history details
    struct ServiceRecord {
        uint256 serviceDate;
        string reason;
        address serviceCentre;
    }

    // Admin address
    address public admin;

    // Role and permission mappings
    mapping(address => bool) public isRetailer;
    mapping(address => bool) public isServiceCentre;
    mapping(address => bool) public authorisedContracts;

    // Token and watch data storage
    uint256 private nextTokenId;
    mapping(string => bool) public usedSerials;
    mapping(uint256 => WatchDetails) private watchDetails;
    mapping(uint256 => ServiceRecord[]) private serviceHistory;

    // Only admin can use these functions
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin");
        _;
    }

    // Set token name, symbol, and admin
    constructor() ERC721("WatchRegistry", "WATCH") {
        admin = msg.sender;
        nextTokenId = 1;
    }

    // Add retailer address
    function addRetailer(address account) external onlyAdmin {
        require(account != address(0), "Invalid address");
        isRetailer[account] = true;
    }

    // Add service centre address
    function addServiceCentre(address account) external onlyAdmin {
        require(account != address(0), "Invalid address");
        isServiceCentre[account] = true;
    }

    // Add authorised contract addresses
    function addAuthorisedContracts(
        address[] memory accounts
    ) external onlyAdmin {

        for (uint256 i = 0; i < accounts.length; i++) {

            require(accounts[i] != address(0), "Invalid address");

            authorisedContracts[accounts[i]] = true;
        }
    }

    // Mint a new watch NFT
    function mintWatch(
        string memory serialNumber,
        string memory model,
        string memory description
    ) external onlyAdmin returns (uint256) {
        require(bytes(serialNumber).length > 0, "Serial required");
        require(!usedSerials[serialNumber], "Serial used");

        uint256 tokenId = nextTokenId;
        nextTokenId++;

        usedSerials[serialNumber] = true;

        watchDetails[tokenId] = WatchDetails(
            serialNumber,
            model,
            description,
            block.timestamp,
            WatchStatus.Registered
        );

        _safeMint(msg.sender, tokenId);
        return tokenId;
    }

    // Send watch to retailer
    function sendToRetailer(uint256 tokenId, address retailer) external onlyAdmin {
        require(_ownerOf(tokenId) != address(0), "Watch does not exist");
        require(ownerOf(tokenId) == msg.sender, "Manufacturer not owner");
        require(isRetailer[retailer], "Not retailer");
        require(retailer != address(0), "Invalid retailer");

        _transfer(msg.sender, retailer, tokenId);
        watchDetails[tokenId].status = WatchStatus.InRetail;
    }

    // Update watch status
    function updateStatus(uint256 tokenId, WatchStatus status) external {
        require(_ownerOf(tokenId) != address(0), "Watch does not exist");

        require(
            msg.sender == admin ||
            authorisedContracts[msg.sender] ||
            msg.sender == ownerOf(tokenId) ||
            isServiceCentre[msg.sender],
            "Not allowed"
        );

        watchDetails[tokenId].status = status;
    }

    // Transfer watch by authorised contract
    function transferByContract(
        uint256 tokenId,
        address from,
        address to,
        WatchStatus status
    ) external {
        require(authorisedContracts[msg.sender], "Not authorised contract");
        require(ownerOf(tokenId) == from, "Wrong owner");
        require(to != address(0), "Invalid address");

        _transfer(from, to, tokenId);
        watchDetails[tokenId].status = status;
    }

    // Mark watch as stolen
    function flagStolen(uint256 tokenId) external onlyAdmin {
        require(_ownerOf(tokenId) != address(0), "Watch does not exist");
        watchDetails[tokenId].status = WatchStatus.Stolen;
    }

    // Get full watch information
    function getWatchInfo(uint256 tokenId)
        external
        view
        returns (
            string memory serialNumber,
            string memory model,
            string memory description,
            address owner,
            string memory status,
            uint256 mintedAt
        )
    {
        require(_ownerOf(tokenId) != address(0), "Watch does not exist");

        WatchDetails memory d = watchDetails[tokenId];

        return (
            d.serialNumber,
            d.model,
            d.description,
            ownerOf(tokenId),
            getStatusName(d.status),
            d.mintedAt
        );
    }


    // Get current owner
    function getOwnerDetails(uint256 tokenId) external view returns (address) {
        require(_ownerOf(tokenId) != address(0), "Watch does not exist");
        return ownerOf(tokenId);
    }

    // Get one service record
    function getServiceRecord(uint256 tokenId, uint256 index)
        external
        view
        returns (
            uint256 serviceDate,
            string memory reason,
            address serviceCentre
        )
    {
        ServiceRecord memory record = serviceHistory[tokenId][index];

        return (
            record.serviceDate,
            record.reason,
            record.serviceCentre
        );
    }
    // Get total number of service records for a watch
    function getServiceRecordCount(uint256 tokenId)
        external
        view
        returns (uint256)
    {
    require(_ownerOf(tokenId) != address(0), "Watch does not exist");

    return serviceHistory[tokenId].length;
    }

    // Get total minted watches
    function getTotalMinted() external view returns (uint256) {
        return nextTokenId - 1;
    }

    // Convert status enum to text
    function getStatusName(WatchStatus status) internal pure returns (string memory) {
        if (status == WatchStatus.Registered) return "Registered";
        if (status == WatchStatus.InRetail) return "InRetail";
        if (status == WatchStatus.Owned) return "Owned";
        if (status == WatchStatus.InService) return "InService";
        if (status == WatchStatus.Serviced) return "Serviced";
        if (status == WatchStatus.Stolen) return "Stolen";
        return "";
    }
    
    // Disable approvals
    function approve(address, uint256) public pure override {
        revert("Approval disabled");
    }

    function setApprovalForAll(address, bool) public pure override {
        revert("Approval disabled");
    }

    function getApproved(uint256)
        public
        pure
        override
        returns (address)
    {
        revert("Approvals disabled");
    }

    function isApprovedForAll(address, address)
        public
        pure
        override
        returns (bool)
    {
        revert("Approvals disabled");
    }

    // Disable transfers
    function safeTransferFrom(
        address,
        address,
        uint256,
        bytes memory
    ) public pure override {
        revert("Safe transfer disabled");
    }
}