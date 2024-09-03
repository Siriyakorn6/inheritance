// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract Inheritance {
    address owner;
    Inheritor[] public inheritors;
    uint256 public lastAlive;

    struct Inheritor {
        address payable inheritorAddress;
        string name;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    constructor() {
        owner = msg.sender;
        lastAlive = block.timestamp;
    }

    // 1. เติมเงินลงในกองทุน
    function addFunds() external payable {}

    // 2. ดูยอดเงินในกองทุน
    function viewPoolBalance() external view returns (uint256) {
        return address(this).balance;
    }

    // 3. เพิ่มผู้รับมรดก
    function addInheritor(address payable inheritorAddress, string calldata name) external onlyOwner {
        inheritors.push(Inheritor(inheritorAddress, name));
    }

    // 4. ลบผู้รับมรดก
    function removeInheritor(address inheritorAddress) external onlyOwner {
        for (uint256 i = 0; i < inheritors.length; i++) {
            if (inheritors[i].inheritorAddress == inheritorAddress) {
                inheritors[i] = inheritors[inheritors.length - 1];
                inheritors.pop();
                break;
            }
        }
    }

    // 5. ดูรายชื่อผู้รับมรดก
    function viewInheritors() external view returns (Inheritor[] memory) {
        return inheritors;
    }

    // 6. แจกจ่ายมรดกตามที่กำหนดเอง
    function distributeInheritance(address payable[] calldata inheritorAddresses, uint256[] calldata amounts) external onlyOwner {
        require(inheritorAddresses.length == amounts.length, "Mismatched addresses and amounts");
        
        uint256 totalAmount = 0;
        for (uint256 i = 0; i < amounts.length; i++) {
            totalAmount += amounts[i];
        }

        require(totalAmount <= address(this).balance, "Insufficient balance in the contract");

        for (uint256 i = 0; i < inheritorAddresses.length; i++) {
            inheritorAddresses[i].transfer(amounts[i]);
        }
    }

    // 7. รักษาสัญญาให้คงอยู่ ("keep alive")
    function keepAlive() external onlyOwner {
        lastAlive = block.timestamp;
    }

    // 8. ตรวจสอบว่ามีการ keep alive
    function isAlive() external view returns (bool) {
        return (block.timestamp - lastAlive) < 365 days;
    }
}
