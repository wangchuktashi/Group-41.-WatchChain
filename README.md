This project is for educational purposes only.

WatchChain is a blockchain-based watch authentication and ownership tracking system built using Ethereum smart contracts and a web interface. 
The project allows manufacturers, retailers, service centres, and owners to securely manage luxury watch records on the blockchain.
The project uses Ethereum smart contracts with the Sepolia testnet for development and testing.

The system uses NFTs (ERC-721 tokens) to represent watches and stores ownership, service history, and authenticity data permanently on-chain.

The project includes:
1. Smart contracts written in Solidity
2. Frontend webpages using HTML, CSS, and JavaScript
3. MetaMask wallet integration
4. Ethereum interaction using ethers.js

The homepage connects the user wallet and redirects them to the correct dashboard depending on their role.

Features/Contracts:
1. Manufacturer
- Register new watches
- Mint watch NFTs
- Store watch details
- Manage retailers and service centres
- Update watch status


2. Retailer:
- Sell watches to customers
- Transfer ownership
- View watch information

3. Owner / Buyer:
- Verify watch authenticity
- Check ownership
- View service history
- Transfer watches to another owner

4. Service Centre:
- Mark watches as in service
- Add service records
- Return watches after servicing

Smart Contract Features:
- ERC-721 NFT ownership
- Permanent blockchain records
- Role-based access control
- Service history tracking
- Stolen watch detection

Example Workflow
1. Manufacturer: Creates and mints a watch NFT
2. Retailer: Sells the watch to a customer
3. Owner: Verifies authenticity. Checks ownership
4. Service Centre: Adds service records
5. Buyer: Verifies full watch history before purchasing

Security Features:
- Blockchain immutability
- Wallet authentication
- Role-based permissions
- Ownership verification
- Permanent service history

Running with Remix IDE:
- Open Remix IDE
- Upload Solidity contracts
- Compile contracts
- Deploy main contract(Mainufacturer) and copy its address
- Deploy other contract(s) using the copied address
- Copy deployed addresses into config.js

MetaMask Setup:
- Install the MetaMask browser extension
- Connect MetaMask to Remix 
- Deploy Contracts
- Connect wallet using the webpage button

Simplified Stakeholder Actions Table

Stakeholder	Can Do	Cannot Do
Manufacturer	Register a new watch, create the first blockchain record, mint the watch token, set initial watch details	Cannot service a watch, cannot transfer ownership as a retailer sale, cannot change admin permissions unless also admin
Retailer	View watch details, confirm receipt, update watch status, sell/transfer watch to first owner	Cannot register a brand-new watch, cannot add service records, cannot manage roles
Service Centre	View watch details, add service/repair history, update service-related status	Cannot register a new watch, cannot sell the watch, cannot transfer ownership unless also the owner, cannot manage roles
Owner	View watch details, verify watch history, transfer ownership to another owner	Cannot register a new watch, cannot mint tokens, cannot add official service records unless also an authorised service centre, cannot manage roles
Admin	Add/remove authorised roles, manage permissions, flag a watch as disputed/stolen/compromised, view all records	Should not perform normal manufacturer, retailer, or service actions unless explicitly given those roles too
Public Verification Function	Check if watch exists, check authenticity/provenance summary, view non-sensitive history	Cannot edit anything, cannot transfer ownership, cannot add records, cannot manage roles

⸻

Even Simpler Action View

Action	Manufacturer	Retailer	Service Centre	Owner	Admin	Public Check
Register watch	Yes	No	No	No	Yes	No
Mint watch token	Yes	No	No	No	Yes	No
Update watch status	Yes	Yes	Yes	Limited	Yes	No
Add service history	No	No	Yes	No	Yes	No
Transfer ownership	No	Yes (first sale)	No	Yes	Yes	No
View watch details	Yes	Yes	Yes	Yes	Yes	Limited
Verify authenticity	Yes	Yes	Yes	Yes	Yes	Yes
Manage permissions	No	No	No	No	Yes	No
Flag disputed/stolen	No	No	No	No	Yes	No

⸻

Recommended Rule Set

Rule	Meaning
One watch can only be registered once	Prevent duplicate records
Only manufacturer can create a watch	Keeps origin trusted
Only retailer can sell to first owner	Keeps first sale clear
Only current owner can transfer ownership later	Prevents invalid transfers
Only service centre can add service records	Keeps maintenance trusted
Only admin can manage roles and disputes	Keeps permissions controlled
Public users can only verify, not edit	Makes verification easy and safe

⸻

Updated Project Assumptions

Item	Decision
Physical identifier	Serial number only
Barcode	Not used
NFC	Not used
Authenticity check	Based on serial number matching a registered blockchain record
Scope reason	Keeps the project simpler and focused on blockchain logic



Author:
Amarjot Saini and Tashi Wangchuk
