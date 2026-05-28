This project is for educational purposes only.

WatchChain is a blockchain-based watch authentication and ownership tracking system built using Ethereum smart contracts and a web interface. 
The project allows manufacturers, retailers, service centres, and owners to securely manage luxury watch records on the blockchain.

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

Author:
Amarjot Saini and Tashi Wangchuk
