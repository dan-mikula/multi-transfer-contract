// SPDX-License-Identifier: MIT
// test token - d.m. ph33r!1337
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract USDT is ERC20, ERC20Burnable, Ownable {
    constructor() ERC20("Tether USD", "USDT") {
        _mint(msg.sender, 100000000 * 10**18);
    }

    function createSupply(uint256 _amount) public onlyOwner {
        require(_amount > 0, "Please provide an amount that is bigger than 0");
        _mint(msg.sender, _amount);
    }
}
