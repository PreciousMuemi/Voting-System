// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;// Using a recent Solidity version, staying current!

//  import "hardhat" ; // This is for debugging, usually removed for deployment.

/**
 * @title Owner
 * @dev This contract is all about who's the boss. Sets and lets you change the owner.
 */
contract Owner {

    address private owner; // Storing the address of the main person in charge.

    // Event to announce when the boss changes. Good for tracking who's been in charge.
    event OwnerSet(address indexed oldOwner, address indexed newOwner);

    // Modifier to make sure ONLY the owner can call certain functions.
    // Like a VIP pass, but for contract functions.
    modifier isOwner() {
        // If the person calling isn't the owner, stop everything and throw an error.
        // 'require' is like a bouncer checking IDs.
        require(msg.sender == owner, "Nah, you're not the owner.");
        _; // This means "carry on with the function code if the require passed".
    }

    /**
     * @dev Constructor: Runs only once when the contract is born!
     * Sets the person who deployed the contract as the first owner.
     */
    constructor() {
        // console.log("Owner contract deployed by:", msg.sender); // This line is mostly for testing/debugging in Hardhat. See notes below!
        owner = msg.sender; // Setting the deployer as the OG owner.
        emit OwnerSet(address(0), owner); // Announcing the first owner (from zero address).
    }

    /**
     * @dev Change the boss! Only the current owner can transfer ownership.
     * @param newOwner The address of the new boss.
     */
    function changeOwner(address newOwner) public isOwner { // Using the 'isOwner' VIP pass here!
        // Gotta make sure the new owner address isn't the zero address (like sending it to nowhere).
        require(newOwner != address(0), "Can't transfer ownership to the zero address, fam.");
        emit OwnerSet(owner, newOwner); // Announce the change!
        owner = newOwner; // Update who the boss is.
    }

    /**
     * @dev Who's the boss right now? Ask this function.
     * @return address The address of the current owner.
     */
    function getOwner() external view returns (address) {
        return owner; // Just returning the stored owner address. Easy.
    }
}
