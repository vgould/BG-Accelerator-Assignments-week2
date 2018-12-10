// CrowdSale.sol

pragma solidity ^0.4.24;

import "./IERC20.sol";
import "./SafeMath.sol";

contract Crowdsale {

    using SafeMath for uint256;

    uint256 private cap;        // maximum amount of ether to be raised
    uint256 private weiRaised;  // current amount of wei raised
    uint256 private rate;       // price in wei per smallest unit of token (e.g. 1 wei = 10 smallet unit of a token)

    address private wallet;     // wallet to hold the ethers
    IERC20  private token;      // address of erc20 tokens

   /**
    * Event for token purchase logging
    * @param purchaser who paid for the tokens
    * @param beneficiary who got the tokens
    * @param value weis paid for purchase
    * @param amount amount of tokens purchased
    */

    event TokensPurchased(
        address indexed purchaser,
        address indexed beneficiary,
        uint256 value,
        uint256 amount
    );

    // -----------------------------------------
    // Public functions (DO NOT change the interface!)
    // -----------------------------------------
   /**
    * @param _rate Number of token units a buyer gets per wei
    * @dev The rate is the conversion between wei and the smallest and indivisible token unit.
    * @param _wallet Address where collected funds will be forwarded to
    * @param _token Address of the token being sold
    */

    constructor(uint256 _rate, address _wallet, IERC20 _token) public {

        // validate the parameters here

        require(_rate    > 0);
        require(_wallet != address(0));
        require(_token  != address(0));

        // set private variables to parameters

        rate   = _rate;
        wallet = _wallet;
        token  = _token;
    }

    /**
    * @dev Fallback function for users to send ether directly to contract address
    */

    function() external payable {

        buyTokens(msg.sender);
    }

    function buyTokens(address beneficiary) public payable {
    
        // Below are some general steps that should be done.
        // You need to decide the right order to do them in.
        //  - Validate any conditions
        //  - Calculate number of tokens
        //  - Update any states
        //  - Transfer tokens and emit event
        //  - Forward funds to wallet


        uint256 weiAmount = msg.value;
        cap               = token.totalSupply();
     
        // Step 1 - validate initial conditions

        require(beneficiary  != address(0));
        require(weiAmount    != 0);
        require(capReached() == false);

        // Step 2 - calculate the number of tokens

        uint256 tokens = weiAmount.mul(rate);

        // Step 3 - update any states

        weiRaised = weiRaised.add(weiAmount);
        
        // Step 4 - transfer tokens and emit event

        token.transfer(beneficiary, tokens);
        emit TokensPurchased(msg.sender, beneficiary, weiAmount, tokens);
        
        // Step 5 - forward funds to wallet

        wallet.transfer(msg.value);
    }

    /**
    * @dev Checks whether the cap has been reached.
    * @return Whether the cap was reached
    */

    function capReached() public view returns (bool) {

        if (weiRaised >= cap.mul(rate))
            return true;
        else
            return false;
    }


    // -----------------------------------------
    // Internal functions (you can write any other internal helper functions here)
    // -----------------------------------------


}

