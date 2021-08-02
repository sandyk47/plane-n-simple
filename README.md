![plns_logo](/sandbox/front_end_dev/images/plane_simple_logo.png)

## PlaneSimple

The PlaneSimple marketplace is your portal to frictionless aviation asset transactions. Once in possession of your $PLNS tokens, you can use them to list your aircraft or lease a new aircraft, all in one simple interface.  

## __What problem does PlaneSimple solve?__    

PlaneSimple helps to reduce friction between:
* Aircraft owners with unused assets and;
* Aircraft operators with a need for aircraft.  

Allowing these two parties to interact without the need for a theird party intermediary (Leasing Companies) will significantly reduce costs as well as increase aircraft utilization rates.  

It is estimated that around 46% of the worlds air transport category aircraft are currently being operated under a lease agreement - a number that grows year on year (statitsa)  

<img src="/sandbox/front_end_dev/images/lease_percentage2020.png" alt="airlease" width="600"/>

Air Lease Corporation - one of the USA's biggest Aircraft leasing company reported an annual revenue of $2.0 Billion, and a net income of $500.9 million in 2021.  

<img src="/sandbox/front_end_dev/images/airlease_ar.png" alt="airlease" width="500"/>

PlaneSimple aims to capture some of this revenue, while at the same time improving Airline Profitability.


We leverage smart contracts on Ethereum to facilitate trustless transactions between the Owner and the Lessee. All funds are locked in escrow until certain conditions are met for release, ensuring counter-party risk is at a minimum.  

Our platform uses a native currency (the $PLNS token) to settle all transactions related to the registration, listing, and leasing of aircraft.  

<img src="/sandbox/front_end_dev/images/aeroplane_2.png" alt="Your image title" width="400"/>

## $PLNS

<img src="/sandbox/front_end_dev/images/flowchrt.png" alt="flow" width="1200"/>

$PLNS is a fungible token, built to the ERC-20 token standard. It is designed to be an all purpose alternate currency that allows owners and users to transact and lease in the PlaneSimple marketplace.  

## Tokenomics

| $PLNS TOKEN DETAIL |      | Future Considerations  
| ----------- | ----------- |-----------  
| SYMBOL      | $PLNS       |  
| Supply Cap  | 1,000,000   |Could increase (unit bias)  
| Exchange rate| .001ETH   |Could reduce as above  
| Standard  | ERC-20   |  
| Blockchain  | Ethereum   |Multi-Chain?  
| Decimals  | 0   |Simple for testing, needs altering

## Utility  

The $PLNS token will be the native currency for all transactions on the PlaneSimple Marketplace
	* Owners must use $PLNS to register aircraft and pay a listing fee. 
	* Operators must purchase $PLNS to pay their leasing costs to the aircraft owner.  

$PLNS can be purchased through our initial crowdsale at a rate of .001ETH per PlaneToken.  

After the initial sale, all remaining $PLNS tokens will be burned and those that were purchased will be free to trade on the open market.  

## Minting:  
* The team will retain the ability to mint new tokens in order to inflate the supply as necessary. This will be critical for funding the team as well as adding some stability to the $PLNS price ($USD)
    
## Timeline


![rmap](/sandbox/front_end_dev/images/roadmap_white.png)

## Usage

### How to buy $PLNS

* Head to [PlaneSimple](http://planesimple.com "PlaneSimple.com") and connect your Web3 Wallet: Here's an example of the display on the top right of screen once a wallet is connected.
<img src="/sandbox/front_end_dev/images/connectwalletscr.png" alt="mrkt" width="300"/>

* click on "Marketplace". 
<img src="/sandbox/front_end_dev/images/market_scrn.png" alt="mrkt" width="800"/>

* Input the amount of ETH you would like to spend (exchange rate is .001ETH per $PLNS). 
<img src="/sandbox/front_end_dev/images/buyplnsscr.png" alt="mrkt" width="800"/>

### Aircraft Owners (Lessors)

Once you have aquired your $PLNS. 

* click on "Register Plane".
<img src="/sandbox/front_end_dev/images/reg_scrn.png" alt="reg" width="800"/>

* Once your aircraft details have been recorded, you can set your desired rate.  

* A small listing fee will be deducted from toue $PLNS token balance.  

* You're done! Now sit back, relax and wait for offers.  

* When an offer is made, you will be notified and have the ability to accept or decline.

### Aircraft Operators (Lessees)

Head to [PlaneSimple](http://planesimple.com "PlaneSimple.com") and click on 'Marketplace', then 'Lease a Plane. 
<img src="/sandbox/front_end_dev/images/Lease_scr.png" alt="lsscrn" width="800"/>

Select your desired aircraft from the list of available assets.  

Input the date range desired as well as the minimum number of flying hours you wish to use. This will send an offer to the aircraft owner who will either approve or deny the lease.  

Once approved, a 20% deposit amount will be deducted from your $PLNS token balance.  

You are ready to pick up your airplane!  

## Challenges

* Solidity
	Many challenges were encountered in the design of the system of smart contracts. As new developers in Solidity there was a steep learning curve in the process of deploying multiple contracts 	that are required to interact with each other.  

* IPFS
	IPFS - whilst a valuable tool for a project like this - was difficult to work with given it is still a relatively new concept for the team. 

* Tokenomics
	Designing a token that meets the needs of the platform and its users is a difficult task. Considerations were;
	* Supply
	* Inflationary or fixed cap?
	* Price stability - whilst it is desirable for potential investors to see an increase in the value of the token, this creates challenges for the users of the platform. Solutions to this could include mechanisms to peg the price to the USD, or flexible leasing costs which can be altered should the price of $PLNS move too severely.


Risk:

The following were the major risks identified by the team in relation to the project:

1. Users might find it difficult to understand the process of token acquisition as they will need to download and set up a Wallet app along with the creation of their human non-readable address. 

2. Users might lose their private key or delete the app or purchase a new phone without transferring app data to the new one. As a result, they lose access to the tokens. 

3. Users might become victims of a phishing attack and give away their private key. 

4. Legal risks assessment is outside of the scope of this document, however, the areas to explore are as follows - understanding of prerequisites and implication of potential selling of a crypto-object in exchange for fiat money as well as tradability of this object and potential speculative assessment of its nature by regulating authorities.



