
//const ADDRESSES = {
  //  manufacturer: "0x0741f7550e6fA1c7b0eeB556e47F6B4b90651b49",
    //owner:        "0xCdAe2e018d76d972167B4913594Ef249451AC7d0",
    //retailer:     "0x228E3C85ec6B580e67FB711C94B25B22B2eD5951",
    //service:      "0x3d06f62529f5cF08A75FF975729E73826400a31D"
//};


 const ADDRESSES = {
     manufacturer: "0x3fEc244FC0422471CBB94c5C10AC955AED7dd63c",
     owner:        "0x141507797fcdD98862eB10823E466172b14ED568",
     retailer:     "0x8148074C98598e33A7C2D2d40D737f48Bc9473fF",
     service:      "0x9520A84daAB2b1bA20065125a3Cd7e5118654e25"
 };





const MANUFACTURER_ABI = [
    "function admin() view returns (address)",                  // who deployed the contract

    "function isRetailer(address) view returns (bool)",         // Checks if the wallet is a retailer
    "function isServiceCentre(address) view returns (bool)",    // Checks if the wallet is a Service Centre

    "function addRetailer(address)",                            // Add a retailers wallet
    "function addServiceCentre(address)",                       // Add a service center wallet

    "function addAuthorisedContracts(address[])",               // let the other contracts talk to this one

    "function mintWatch(string,string,string) returns (uint256)", // create a new watch on the blockchain
    
    "function sendToRetailer(uint256,address)",                 // send a watch to a retailer
    "function flagStolen(uint256)",                             // mark a watch as stolen
    "function getWatchInfo(uint256) view returns (string serialNumber,string model,string description,address owner,string status,uint256 mintedAt)",
    "event Transfer(address indexed from,address indexed to,uint256 indexed tokenId)" // goes off every time a watch moves
];

const OWNER_ABI = [
    "function verifyOwner(uint256) view returns (bool)",        // Checks if the wallet is the same as whats marked to the watch
    "function checkOwner(uint256) view returns (address)",      // Checks who owns the watch
    "function verifyWatch(uint256) view returns (string serialNumber,string model,string status)"
];

const RETAILER_ABI = [
    "function sellToCustomer(uint256,address)",     // Sell a watch to a buyer
    "function transferToNewOwner(uint256,address)"  // Move a watch to someone else
];

const SERVICE_ABI = [
    "function markInService(uint256)",                          // To mark that a watch is being worked on at a service center
    "function addServiceDetails(uint256,string,string)",        // Save the service done to the blockchain
    "function returnToOwner(uint256,address)",                  // Mark the watch back is out of service and back to the owner
    "function getServiceRecordCount(uint256) view returns (uint256)", // Show the number of times it has been serviced
    "function getServiceDetails(uint256,uint256) view returns (string reason,string details,address serviceCentre,uint256 servicedAt)"
];

// Shortcut code so it saves lines everytime their are needed
const $            = id => document.getElementById(id);
const val          = id => $(id).value.trim();
const makeContract = (address, abi, signer) => new ethers.Contract(address, abi, signer);

// Shows the success message
function show(id, message) {
    const box = $(id);
    box.textContent = message;
    box.className = "status-box success";
    box.style.display = "block";
}

// MetaMask connect feature
async function connect() {
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    await provider.send("eth_requestAccounts", []); // this pops up the MetaMask window
    const signer = provider.getSigner();             // the signer is what lets us send transactions
    return { signer, address: await signer.getAddress() };
}

js// Sends a transaction to the blockchain
async function runTransaction(statusId, target, action, successMessage) {
    const tx      = await action();  // Starts transaction
    const receipt = await tx.wait(); // Waiting for transaction
    show(statusId, successMessage(receipt));
}

// Takes all the watch data and turns it into text we can show on screen
function watchText(tokenId, watch) {
    return [
        "Token ID: "    + tokenId,
        "Serial: "      + watch.serialNumber,
        "Model: "       + watch.model,
        "Status: "      + watch.status,
        "Description: " + watch.description,
        "Owner: "       + watch.owner,
        "Minted: "      + new Date(watch.mintedAt.toNumber() * 1000).toLocaleString()
    ].join("\n");
}

// Looks up a watch on the blockchain and shows its details
async function showWatch(statusId, manufacturer, tokenId) {
    try {
        const info = await manufacturer.getWatchInfo(tokenId);
        show(statusId, watchText(tokenId, info));
    } catch (error) {
        show(statusId, error.message, "error");
    }
}

// Loads all the service history for a watch and puts it on the page
async function showHistory(statusId, outputId, service, tokenId) {
    const total  = (await service.getServiceRecordCount(tokenId)).toNumber(); // Shows how many records their are
    const output = $(outputId);
    output.innerHTML = ""; // Wipe anything that was showing before

    // Loop through each record to add all off them
    for (let i = 0; i < total; i++) {
        const record = await service.getServiceDetails(tokenId, i); // Gets each record from the blockchain
        const date   = new Date(record.servicedAt.toNumber() * 1000).toLocaleString(); // Shows the date in a normal format
        output.innerHTML += `<b>Record #${i + 1}</b><br>Reason: ${record.reason}<br>Details: ${record.details}<br>Centre: ${record.serviceCentre}<br>Date: ${date}<br><br>`;
    }
    show(statusId, `Found ${total} record(s).`);
}

// Works out what role the connected wallet has and sends them to the right page
async function openMyPage() {
    const wallet       = await connect();
    const manufacturer = makeContract(ADDRESSES.manufacturer, MANUFACTURER_ABI, wallet.signer);
    const account      = wallet.address.toLowerCase(); // we lowercase both sides so the comparison always works

    if      (account === (await manufacturer.admin()).toLowerCase()) location.href = "manufacturer.html";
    else if (await manufacturer.isServiceCentre(wallet.address))    location.href = "service.html";
    else if (await manufacturer.isRetailer(wallet.address))         location.href = "retailer.html";
    else                                                             location.href = "owner.html"; // If none of the address match then redirect to the owner page.
}