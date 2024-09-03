// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract inheritance { //ชื่อ
     address owner; //ที่อยู่ กับ เจ้าของ
     Inheritor[] inheritor;

    constructor(){ //วิ่งครั้งแรก
        owner = msg.sender;
    }
 //1. put fund in smart contract

    function addtips() payable public {

    }

    //2. view balance

    function viewtips() public view returns(uint){
        return address(this).balance;  
     }

    //3.1 add structure inheritor
    struct Inheritor{
        address payable inheritorAddress;
        string name;
    }

    //3.2 add inheritor
    function addInheritor(address payable inheritorAddress,string memory name) public {
        require(msg.sender == owner, "Only the owner can call this function");
        bool inheritorExist = false;

        if(inheritor.length >=1){
        for (uint i=0; i<inheritor.length; i++) {
           if(inheritor[i].inheritorAddress == inheritorAddress){
            inheritorExist = true;
           }

        }
       
        }
        if(inheritorExist==false){
           inheritor.push(Inheritor(inheritorAddress,name));

        }
    }

    //4. remove user
    function removeInheritor(address payable inheritorAddress) public{
        if(inheritor.length>=1){
            for(uint i=0; i<inheritor.length; i++){
                if(inheritor[i].inheritorAddress==inheritorAddress){
                    for(uint j=i; j<inheritor.length-1; j++){
                        inheritor[j]=inheritor[j+1];
                    }
                   inheritor.pop();
                    break;
                }

            }
            
        }
    }

    //5. view inheritor
    function viewInheritor() public view returns(Inheritor[] memory) {
       return inheritor;
    }


    //6.distribute tips
    function distrubiteInheritor() public{
        require(address(this).balance > 0, "Insufficient balance in the contract");
        if(inheritor.length>=1){
            uint amount = address(this).balance / inheritor.length;
            for (uint i=0; i<inheritor.length; i++){
                transfer(inheritor[i].inheritorAddress,amount);
            }
        }
    }
    //transfer money
    function transfer(address payable inheritorAddress,uint amount) internal{
        inheritorAddress.transfer(amount);
    }

}