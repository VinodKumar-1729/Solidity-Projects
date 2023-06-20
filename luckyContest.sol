//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract Lottery{
    address public manager;
    address payable[] public participants;
    constructor(){
        manager = msg.sender;
    }
    receive() external payable {
        require(msg.value == 2 ether);
        participants.push(payable(msg.sender));
    }
    function getBalance() public view returns(uint){
        require(msg.sender == manager);
        return address(this).balance;
    }
    function random() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.prevrandao,block.timestamp,participants.length)));
    }
    //block.difficulty or block.prevrando, it is based on the network the we are going to deploy
    function selectWinner() public{
        require(participants.length>=3);
        require(msg.sender== manager);
        uint r = random();
        address payable winner;
        uint index = r % participants.length;
        winner = participants[index];
        winner.transfer(getBalance());
        participants = new address payable[] (0);
    }
}
