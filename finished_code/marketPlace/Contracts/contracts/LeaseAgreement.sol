pragma solidity ^0.6;
import "./LeasablePlane.sol";
contract LeaseController {

    event LeaseContractCreated(uint timestamp, address newLeaseContractAddress, address planeOwner);
    address[] contracts;
    struct Contract{
        address plane_owner;
        address lessee;
        uint start_date;
        uint end_date;
        bool complete;
    }
    mapping(uint => Contract) public leaseContracts;

    function createLease( uint _start_timestamp,
        uint _end_timestamp) public returns(PlaneLeaseContract) {

        PlaneLeaseContract pln_ctrct= new PlaneLeaseContract(msg.sender,   _start_timestamp,
         _end_timestamp)   ;

       address newLeaseContract = address(pln_ctrct);
        contracts.push(address(newLeaseContract));
       
        
        emit LeaseContractCreated(block.timestamp, newLeaseContract, msg.sender);
         return pln_ctrct;
    }

    function getLeases() external view returns (address[] memory) {
        return contracts;
    }

    function getNumLeases() external view returns (uint) {
        return contracts.length;
    }


}

contract PlaneLeaseContract {


    struct Lessee {
        uint leaseAmount;
        uint depositAmount;
        bool hasSigned;
        bool hasPaidDeposit;
        bool initialized;
    }
    enum Status{inactive,proposed,assigned,signing,signed,active,executed}
    Status leaseStatus = Status.inactive;

    mapping(address => Lessee) public lesseeAddress;
        Lessee[] public lessees;

    address payable public planeOwnerAddress;
    string public writtenContractIpfsHash;
    
   
    uint public deposit;
    uint public  start_timestamp;
    uint  public end_timestamp;
    bool public  owner_released = false;
    //mapping(address => uint) pendingReturns;

    /*** events */

    event WrittenContractProposed(uint timestamp, string ipfsHash);
    event LesseeAssigned(uint timestamp, address tenantAddress, uint leaseAmount, uint depositAmount);
    event LesseeSigned(uint timestamp, address lessseeAddress);
    event DepositPayed(uint timestamp, address lesseeAddress, uint amount);
    event PlaneReceived(uint timestamp, address lesseeAddress);
    event PlaneReleasedByOwner(uint timestamp, address planeOwn);
   
    // inheritance would be an issue with external constructors
    constructor(address payable _planeOwnerAddress,  uint _start_timestamp,
        uint _end_timestamp) public {
        require(_planeOwnerAddress != address(0), "Plane address must not be zero!");
        planeOwnerAddress = _planeOwnerAddress;
        start_timestamp=_start_timestamp;
        end_timestamp=_end_timestamp;

       
    }

    modifier onlyLessee() {
        require(lesseeAddress[msg.sender].initialized == true, "Only Lessee can invoke this functionality");
        _;
    }

    modifier onlyPlaneOwner() {
        require(msg.sender == planeOwnerAddress, "Only the plane owner can invoke this functionality");
        _;
    }

    modifier isContractProposed() {
        require(!(isSameString(writtenContractIpfsHash, "")), "The written contract has not been proposed yet");
        _;
    }

    modifier hasSigned() {
        require(lesseeAddress[msg.sender].hasSigned == true, "Lessee must sign the contract before invoking this functionality");
        _;
    }
    
     modifier notZeroAddres(address addr){
        require(addr != address(0), "0th address is not allowed!");
        _;
    }

    function proposeWrittenContract(string calldata _writtenContractIpfsHash) external onlyPlaneOwner {
        // Update written contract ipfs hash
        writtenContractIpfsHash = _writtenContractIpfsHash;
        leaseStatus = Status.proposed;
        emit WrittenContractProposed(block.timestamp, _writtenContractIpfsHash);
    }

    function assignLessee(address _lesseeAddress, uint _leaseAmount, uint _depositAmount)
        external onlyPlaneOwner isContractProposed notZeroAddres(_lesseeAddress){
      
       
        require(_lesseeAddress != planeOwnerAddress, "Owner is not allowed to be a lessee.");
        require(lesseeAddress[_lesseeAddress].initialized == false, "Duplicate lessees  not allowed.");
        // TODO: Create Right lessee structure here
        lessees.push(Lessee(_leaseAmount, _depositAmount, false, false, true));
        leaseStatus = Status.proposed;
        //lesseeAddress[_lesseeAddress] = lessees[address];
   

        emit LesseeAssigned(block.timestamp, _lesseeAddress, _leaseAmount, _depositAmount);
    }
    /*** how to allow the lessee to see assigned lease? */

    function signContract() external onlyLessee isContractProposed {
        require(lesseeAddress[msg.sender].hasSigned == false, "The lessee has already signed the contract");

        // Lesse signed
        lesseeAddress[msg.sender].hasSigned = true;
        leaseStatus = Status.signed;
        


        emit LesseeSigned(block.timestamp, msg.sender);
    }

    function payDeposit() external payable onlyLessee hasSigned {
        require(msg.value == lesseeAddress[msg.sender].depositAmount,
            "Amount of provided deposit does not match the amount of required deposit");

        require(lesseeAddress[msg.sender].hasPaidDeposit == false, "The lessee has already paid the deposit");
        require(lesseeAddress[msg.sender].hasSigned == true, "please sign the aggreeement first");

        deposit += msg.value;
        lesseeAddress[msg.sender].hasPaidDeposit = true;

        //ask to releaseplane 
        LeasablePlane the_plane = LeasablePlane(planeOwnerAddress);
        the_plane.releasePlane(address(this));
        leaseStatus = Status.active;
        //TODO: ESCROW

        emit DepositPayed(block.timestamp, msg.sender, msg.value);
    }
    //address _contactAddress
   function confirmPlaneReceived() external onlyLessee {
       // release witholding money
       // this confirms that the lessee has received the plane
       //pay the plane_owner 
       require(leaseStatus == Status.active,
            "Plane not yet released");
        leaseStatus = Status.executed;
        emit PlaneReceived(block.timestamp, msg.sender);// "Plane Received by Lessee");

   }
   function returnPlane()external onlyLessee{}

   function releasePlane()external onlyPlaneOwner {
       //let the lessee know for confirmation
       leaseStatus = Status.active;
       owner_released = true;
    emit PlaneReleasedByOwner(block.timestamp,planeOwnerAddress);// "Plane REleased by Owner");


   }

  function isSameString(string memory string1, string memory string2) private pure returns (bool) {
    return keccak256(abi.encodePacked(string1)) == keccak256(abi.encodePacked(string2));
  }
}