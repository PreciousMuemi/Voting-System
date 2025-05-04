// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
// Importing the cool Owner contract I wrote!
// Make sure this path is correct based on where you save your Owner.sol file.
import "./Owner.sol";

/**
 * @title VotingSystem
 * @dev This is where the magic happens! A decentralized voting system.
 * We're inheriting from your awesome Owner contract to keep things tidy and secure.
 * Only the real OG (Original Gangster, aka the owner) can add candidates.
 */
contract VotingSystem is Owner { // Inheriting from your Owner contract - looking good!

    // Okay, so this is like a blueprint for our candidates.
    // Think of it as their profile card in the voting app.
    struct Candidate {
        uint id; // Unique number for each candidate, like their student ID.
        string name; // Their name, gotta know who you're voting for, right?
        uint voteCount; // How many votes they've bagged so far. Let's get this bread!
    }

    // This mapping is like our candidate database.
    // You give it a candidate ID (uint), and it gives you the whole Candidate struct.
    mapping(uint => Candidate) private candidates;

    // This mapping is to make sure nobody's trying to game the system!
    // It tracks if an address (voter) has already cast their vote.
    // True means they've voted, false means they're still deciding (or haven't yet).
    mapping(address => bool) private voters;

    // This is just a counter to give each new candidate a unique ID.
    // Starts at 0 and goes up every time a new candidate is added.
    uint private nextCandidateId;

    // Events are like notifications that something important happened on the blockchain.
    // This one fires when a new candidate joins the race.
    event CandidateAdded(uint id, string name);

    // This event fires every time someone successfully votes.
    // Shows who voted and who they voted for. Transparency is key!
    event Voted(address voter, uint candidateId);

    /**
     * @dev Constructor time! This runs once when you deploy the contract.
     * It automatically makes the person who deploys it the contract owner
     * thanks to the Owner contract we're inheriting from.
     */
    constructor() Owner() {
        // The Owner contract already did the heavy lifting of setting the owner.
        // We just gotta make sure our candidate ID counter is ready to go.
        nextCandidateId = 0; // Starting fresh at zero!
    }

    /**
     * @dev Adding a new contender to the voting list!
     * Only callable by the contract owner. Sorry, plebs! 😉
     * @param name The name of the candidate you're adding.
     *
     * Use 'calldata' here because 'name' is an external function arg (coming from outside)
     * and it's a complex type (string). Calldata is super gas-efficient for this!
     */
    function addCandidate(string calldata name) public isOwner {
        // Sticking the new candidate into our 'candidates' mapping.
        // We use 'nextCandidateId' for their ID and set their vote count to zero initially.
        candidates[nextCandidateId] = Candidate(nextCandidateId, name, 0);

        // Let everyone know a new candidate is in the house!
        emit CandidateAdded(nextCandidateId, name);

        // Increment the counter so the next candidate gets a fresh ID.
        nextCandidateId++;
    }

    /**
     * @dev Time to cast your vote! Choose your fighter!
     * Anyone can call this, but you only get one shot. No double-dipping!
     * @param candidateId The ID of the candidate you want to vote for.
     */
    function vote(uint candidateId) public {
        // First, check if this address has already voted.
        // If voters[msg.sender] is true, they've voted. We gotta stop them.
        require(!voters[msg.sender], "VotingSystem: Bruh, you already voted. One vote per person!");

        // Next, check if the candidate ID they entered is actually valid.
        // Gotta make sure they're voting for someone who exists!
        require(candidateId < nextCandidateId, "VotingSystem: Invalid candidate ID. Who even is that? ");

        // Okay, they're legit. Let's find the candidate in storage and bump up their vote count.
        // Accessing storage directly like this is how you make changes stick on the blockchain.
        candidates[candidateId].voteCount++;

        // Now, mark this address as having voted so they can't vote again.
        // Setting voters[msg.sender] to true locks 'em in.
        voters[msg.sender] = true;

        // Announce to the world that a vote was cast!
        emit Voted(msg.sender, candidateId);
    }

    /**
     * @dev Wanna see how a candidate is doing? Get their deets here.
     * This is a 'view' function, meaning it doesn't change anything on the blockchain,
     * so it's free to call! Gas fees? We don't know her.
     * @param candidateId The ID of the candidate you're curious about.
     * @return name The candidate's name.
     * @return voteCount Their current vote count.
     */
    function getCandidate(uint candidateId) public view returns (string memory name, uint voteCount) {
        // Gotta use 'memory' for returning string data from view functions.
        // Memory is like temporary scratch space during the function call.
        // It's not stored permanently on the blockchain.

        // Still gotta check if the candidate ID is valid, even for a view function. Safety first!
        require(candidateId < nextCandidateId, "VotingSystem: Invalid candidate ID. Still don't know who that is. ");

        // Get a reference to the candidate's data in storage.
        // Using 'storage' here is more efficient than copying the whole struct if we were just modifying it.
        // For returning, we just grab the values we need.
        Candidate storage candidate = candidates[candidateId];

        // Return the name and vote count. Easy peasy.
        return (candidate.name, candidate.voteCount);
    }

    /**
     * @dev How many candidates are in the running? This tells you.
     * Another 'view' function, so it's free!
     * @return The total number of candidates added so far.
     */
    function getTotalCandidates() public view returns (uint) {
        // Just return the current value of our counter. Simple!
        return nextCandidateId;
    }
}
