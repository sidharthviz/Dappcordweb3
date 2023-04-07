// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Dappcord is ERC721 {
   uint256 public totalSupply; 
   uint256 public totalChannels = 0;
   address public owner;          //state variable the variable that belongs to entire contrac
  
  struct Channel {
    uint256 id;
    string name;
    uint256 cost;
  }

  mapping (uint256 => Channel) public channels;
  mapping (uint256 => mapping (address => bool)) public hasJoined;

  modifier onlyOwner {
         require(msg.sender == owner); 
         _;      //requires check the statement if it's not pass then it will revert the function
  }

   constructor(string memory _name, string memory _symbol)
     ERC721(_name, _symbol) 
     {
       owner = msg.sender;
     }

     function createChannel(string memory _name, uint256 _cost) public onlyOwner {
        totalChannels++;
       channels[totalChannels] = Channel(totalChannels, _name, _cost);
     }

     function mint(uint256 _id) public payable {
        require(_id != 0);
        require(_id <= totalChannels);
        require(hasJoined[_id][msg.sender] == false);
        require(msg.value >= channels[_id].cost);

       //Joined channel
       hasJoined[_id][msg.sender] = true;
     
      //mint NFT
      totalSupply++;
        _safeMint(msg.sender, 1);
     }

     function getChannel(uint256 _id) public view returns (Channel memory) {
        return channels[_id];
     }
}
