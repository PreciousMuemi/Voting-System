Decentralized Voting System (Lisk Testnet)
A secure, transparent voting smart contract built on the Lisk Testnet for the Lisk Africa Developer’s Bootcamp (Week 3 Assignment). Implements candidate registration, voting, and result tracking with strict access control.

Solidity
License: MIT
Network: Lisk Testnet

🌟 Features
Candidate Management: Add candidates (owner-only)

Secure Voting:

Prevents double-voting via address tracking

Validates candidate IDs

Results Transparency:

View candidate vote counts

Track total candidates

Ownership Control: Inherits from Ownable base contract

Gas Optimization: Uses calldata, memory, and storage appropriately

📦 Installation
Clone Repository

bash
git clone https://github.com/PreciousMuemi/Voting-System
cd voting-system
Install Dependencies

bash
npm install  # For Hardhat/Foundry projects
# OR
yarn add
🛠 Usage
Deploy Contract (Lisk Testnet)
bash
npx hardhat run scripts/deploy.js --network lisk-testnet
Interact via CLI
javascript
// Add Candidate (Owner Only)
await votingSystem.addCandidate("Alice");

// Vote
await votingSystem.vote(0);  // Candidate ID 0

// Get Results
const [name, votes] = await votingSystem.getCandidate(0);
console.log(`${name}: ${votes} votes`);
🌐 Network Configuration (Lisk Testnet)
Parameter	Value
Network Name	Lisk Testnet
RPC URL	https://testnet.lisk.com
Chain ID	4201
Currency Symbol	LSK
Faucet: Get Testnet LSK

📜 Smart Contract Overview
Contracts
Ownable.sol (Base Contract)

Manages contract ownership

Implements onlyOwner modifier

VotingSystem.sol (Derived Contract)

solidity
// Key Components
struct Candidate {
    uint id;
    string name;
    uint voteCount;  // storage
}

mapping(uint => Candidate) private candidates;  // storage
mapping(address => bool) private voters;        // storage
Functions
Function	Description	Access
addCandidate(name)	Add new candidate	onlyOwner
vote(candidateId)	Cast vote for candidate	Public
getCandidate(id)	View candidate details	Public
getTotalCandidates()	Get total candidates count	Public
🧪 Testing
Run tests with Hardhat/Foundry:

bash
npx hardhat test
# OR
forge test
Test Coverage:

Owner access control

Double-voting prevention

Candidate ID validation

🔒 Security
Reentrancy Guards: Not required (no external calls)

Access Control: Strict onlyOwner modifier

Input Validation:

Valid candidate IDs

Non-zero address checks

🤝 Contributing
Fork the repository

Create your feature branch (git checkout -b feature/your-feature)

Commit changes (git commit -m 'Add feature')

Push to branch (git push origin feature/your-feature)

Open a Pull Request

📄 License
MIT License - See LICENSE for details

🙏 Acknowledgments
Lisk Africa Developer’s Bootcamp

Lisk Testnet Infrastructure