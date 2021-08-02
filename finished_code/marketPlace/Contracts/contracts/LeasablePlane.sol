pragma solidity ^0.6;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "./LeaseAgreement.sol";
import "./LeasableMarket.sol";
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC721/ERC721Full.sol";
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/drafts/Counters.sol";

/**

    ERC721 Token URI JSON Schema

    {
        "title": "Vehicle Metadata",
        "type": "object",
        "properties": {
            "make": {
                "type": "string",
                "description": "Ford"
            },
            "model": {
                "type": "string",
                "description": "Fusion"
            },
            "year": {
                "type": "uint",
                "description": "2014"
            }
        }
    }

**/


contract LeasablePlane is ERC721 {

    using SafeMath for uint;
    using Counters for Counters.Counter;
    Counters.Counter token_ids;
    address public plane_owner;
    uint public rate_per_fh;
    RateType public rate_type;
    address  public lease_offer;
    uint private listing_id;
    // for debug Only
    address public mktplace_Add;
     address public contract_Add;

    //LeaseAgreement[] public lease_agreements;
     string public NAA_REGO;

    enum Status {
        Inactive,
        Registered,
        Offered,
        OfferReceived,
        Released,
        Leased,
        Returning,
        Returned,
        Paused,
        Withdrawn

    }
    enum RateType {Dry,Wet}
    struct Plane {
        string identifier;
        address plane_owner ; 
        bool leasable;
    }
    struct LeaseOffer{
        address offerLessee;
        uint start_timestamp;
        uint end_timestamp;
        uint reqhours;
        
    }
  Status public status = Status.Inactive;
  address public leaseContract;
  LeasableMarket  leaseMarket;
  
  PlaneLeaseContract public  leaseAgreement;

 // Only permanent data that you would need to use within the smart contract later should be stored on-chain
  mapping(uint => Plane) public planes;
  mapping(uint => LeaseOffer) public leaseOffers;

   LeaseController leaseController = new LeaseController();
  modifier atStage(Status _stage) {
        require(
            status == _stage,
            "Function cannot be called at this time. Stage Check"
        );
        _;
    }
   modifier hasPaid() {
     // require(msg.sender == );
    _;
   }
 // events
   event Registered(string rego,address owner, uint token_id, string tok_uri);// (NAA_REGO,plane_owner,token_id,token_uri);
  function nextStage() internal {
        status = Status(uint(status) + 1);
    }
 
  constructor(string memory _NAA_REGO) ERC721("Leasable Plane Ownership Token", "LPOWN") public { 
        

  }
  
   

    event Registered(uint token_id, string ipfsHash);
    event OfferedForLease(uint listing_id, address plane_owner, uint token_id);
    event OfferAccepted( address offercontract, address less);

    function registerPlane(string memory _NAA_REGO, string memory token_uri) public returns(uint) {

        /**** validate PLANE TOKEN BOUGHT */
        /*** deduct Plane Token */
         NAA_REGO=_NAA_REGO;
         plane_owner= msg.sender;

        token_ids.increment();
        uint token_id = token_ids.current();

        _mint(plane_owner, token_id);
        _setTokenURI(token_id, token_uri);

        planes[token_id] = Plane(NAA_REGO, plane_owner,false);
        status = Status.Registered;
        emit Registered(NAA_REGO,plane_owner,token_id,token_uri);
        

        return token_id;
    }
     function offerLease(uint _token_id, uint _rate_per_fh, RateType _rate_type , address _mktplace) public returns(uint) {
         //check msg.sender is plane owner
         //check balance 
        Plane storage  the_plane = planes[_token_id] ;
        the_plane.leasable = true;
        rate_per_fh = _rate_per_fh;
        rate_type=_rate_type;

        //create mktplace andd list 
         leaseMarket =   LeasableMarket(_mktplace);
         listing_id = leaseMarket.registerPlane(address(this),rate_per_fh, getSuitKeyByValue(_rate_type));
         mktplace_Add = address(leaseMarket);
         emit OfferedForLease(listing_id, the_plane.plane_owner,_token_id);
         return listing_id;
        
        
     }
     function receiveOffer(address _requestor,uint _listing,uint _start_timestamp,
        uint _end_timestamp, uint _reqhours) public{
         //lease_offer = _listing;
         leaseOffers[_listing] =  LeaseOffer(_requestor,_start_timestamp,_end_timestamp,_reqhours);
         // LeaseOffer(_requestor,_start_timestamp,_end_timestamp,_reqhours);
         //listing_id = _listing;
         status = Status.OfferReceived;
         

     }
     function checkOffer() public view returns(address){
         return lease_offer;

     }
     function acceptOffer (uint _listing, bool _response, string memory _contractLocation) public returns(address){
         if (_response){
             //createcontract 
             LeaseOffer storage  offer= leaseOffers[_listing];
//             PlaneLeaseContract  leaseAgreement = leaseController.createLease(offer.start_timestamp, offer.end_timestamp);
             leaseAgreement = leaseController.createLease(offer.start_timestamp, offer.end_timestamp);
             leaseAgreement.proposeWrittenContract(_contractLocation);
             //offerLessee
             uint cont_amount =rate_per_fh.mul(offer.reqhours);
             leaseAgreement.assignLessee(offer.offerLessee, cont_amount, cont_amount.div(5));
             lease_offer = 0x0000000000000000000000000000000000000000;
             status = Status.Offered;
             leaseMarket.registerLeased(listing_id);
             //debug
             contract_Add = address(leaseAgreement);
              emit OfferAccepted(contract_Add,offer.offerLessee);

             return contract_Add;
            
         }else{

                lease_offer = 0x0000000000000000000000000000000000000000;
                return lease_offer;
                //update marketplace 
         }
        


     }
     function releasePlane (address _contractAddress) public {
         
         //
             status = Status.Leased;
             leaseContract = _contractAddress;
            PlaneLeaseContract act_contract = PlaneLeaseContract(_contractAddress);
            act_contract.releasePlane();


     }
     function acceptPlaneReturn() public{
         status = Status.Returned;
         // release deposit

     }
     

     function getSuitKeyByValue(RateType ratetype) internal pure returns (string memory) {
        
     // Error handling for input
             
     // Loop through possible options
     if (RateType.Dry == ratetype) return "Dry";
     if (RateType.Wet == ratetype) return "Wet";

}
       
          
   /***  function getLeaseAgreements() 
        public 
        view 
        returns (LeaseAgreement[] memory) 
    {
        return lease_agreements;
    } */


    

}
