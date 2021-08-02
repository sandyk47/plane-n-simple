pragma solidity ^0.6.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import "./LeasablePlane.sol";

contract LeasableMarket  {
    //Plane[] public planes;
    struct Plane {
        address leasP_address ; 
        bool available;
    }
    enum ListStatus{await,received,offered,leased,delisted}// pause if time permits
    
    struct Listings{
        //uint id;
        address the_plane;
        uint rate;
        string rate_type;
        ListStatus status;
        uint list_id;
      
        
    }
    uint[]  public plane_lists;
    ListStatus public listingStatus = ListStatus.await;
    using Counters for Counters.Counter;
    Counters.Counter public mktplace_id;
     uint  public lists = 0;

    mapping(uint => Listings) public plane_listings;

    

    /**events */
      function nextStage() internal {
        listingStatus = ListStatus(uint(listingStatus) + 1);
    }
     function registerPlane(address  _lease_plane_address,uint  _rate, string memory rate_type) public returns(uint) { 
        mktplace_id.increment();
        uint listid =  mktplace_id.current();
        plane_lists.push(listid);
        uint plane_id = plane_lists.length - 1;
        lists +=1;
        
        
       // plane_lists.push(Listings(mktplace_id.current(), _lease_plane_address,_rate,rate_type,ListStatus.received));
        plane_listings[mktplace_id.current()] = Listings(_lease_plane_address,_rate,rate_type,ListStatus.received,plane_id);
        listingStatus = ListStatus.received;
       
      
        return listid;
        //emit list added

  }
       //listing id is mktplaceid
       function registerInterest(uint _listingID,uint _start_timestamp,
        uint _end_timestamp, uint _req_hours) public returns(bool) {
            Listings storage listed_plane = plane_listings[_listingID] ;
            //send to the owner
            LeasablePlane offer_plane = LeasablePlane(plane_listings[_listingID].the_plane);
            offer_plane.receiveOffer(msg.sender,_listingID,_start_timestamp,_end_timestamp,_req_hours);

            listed_plane.status = ListStatus.offered;
            return true;

       }
       function registerLeased(uint _listingID) public{
          // Listings memory listed_plane = plane_listings[_listingID] ;
          Listings storage listed_plane = plane_listings[_listingID] ;
          uint _iden = listed_plane.list_id;
          delete plane_lists[_iden];
          delete plane_listings[_listingID];
          lists -=1;
           //plane_lists.pop(_listingID);
           //listed_plane.status = ListStatus.leased;

       }
       
         function get_planes_length() view  public returns(uint) {  
                return lists;
               
            } 
            
  
       //function getListings() external view returns (Listings[] memory) {
         //return plane_listings;
    //}

              
  

}

/**
List Plane
Place Offer
---> send back to plane owner 
Delist Plane --> 
Lessee
Plane Owner



 */