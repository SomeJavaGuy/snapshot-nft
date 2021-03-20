//Contract based on https://docs.openzeppelin.com/contracts/3.x/erc721
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";


contract PhotoNFT is ERC721, AccessControl {
  string[] public urls;
  string[] public titles;
  mapping(string => bool) _urlExists;


  bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
  bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");

  constructor() ERC721("PhotoNFT", "PHOTONFT") public {
    _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
  }

  function mint(string memory _url, string memory _title) public {
    require(hasRole(MINTER_ROLE, msg.sender), "Caller is not a minter");

    //add url
    require(!_urlExists[_url]);
    urls.push(_url);

    //add title
    titles.push(_title);

    //set id, mint token
    uint _id = urls.length - 1;
    _mint(msg.sender, _id);
    _urlExists[_url] = true;
  }

}