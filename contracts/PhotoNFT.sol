//Contract based on https://docs.openzeppelin.com/contracts/3.x/erc721
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";


contract PhotoNFT is ERC721 {
  string[] public urls;
  string[] public titles;
  mapping(string => bool) _urlExists;


  constructor() ERC721("PhotoNFT", "PHOTONFT") public {
  }

  //TODO create the URI and add a base URI function

  function mint(string memory _url, string memory _title) public {

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