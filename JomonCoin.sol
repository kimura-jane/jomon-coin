// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.0.2/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.0.2/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.0.2/contracts/access/AccessControl.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.0.2/contracts/utils/Pausable.sol";

contract JomonCoin is ERC20, ERC20Capped, AccessControl, Pausable {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    event Migrated(address indexed oldAddr, address indexed newAddr, uint256 amount);

    constructor() ERC20("JOMON COIN", "JOMON") ERC20Capped(10_000) {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }
    function decimals() public pure override returns (uint8) { return 0; }
    function pause() external onlyRole(DEFAULT_ADMIN_ROLE) { _pause(); }
    function unpause() external onlyRole(DEFAULT_ADMIN_ROLE) { _unpause(); }

    function mint(address to, uint256 amount) external onlyRole(MINTER_ROLE) whenNotPaused { _mint(to, amount); }
    function batchMint(address[] calldata to, uint256[] calldata amounts)
        external onlyRole(MINTER_ROLE) whenNotPaused {
        require(to.length == amounts.length, "len mismatch");
        for (uint256 i; i < to.length; ++i) { _mint(to[i], amounts[i]); }
    }
    function migrate(address newAddr) external whenNotPaused {
        require(newAddr != address(0) && newAddr != msg.sender, "bad addr");
        uint256 bal = balanceOf(msg.sender); require(bal > 0, "no balance");
        _burn(msg.sender, bal); _mint(newAddr, bal); emit Migrated(msg.sender,newAddr,bal);
    }
    function adminReissue(address oldAddr, address newAddr, uint256 amount)
        external onlyRole(DEFAULT_ADMIN_ROLE) whenNotPaused {
        require(newAddr != address(0), "bad addr"); _burn(oldAddr, amount); _mint(newAddr, amount);
    }
    function _update(address from, address to, uint256 value)
        internal override(ERC20, ERC20Capped) whenNotPaused {
        if (from != address(0) && to != address(0)) revert("TRANSFER_DISABLED");
        super._update(from, to, value);
    }
    function approve(address, uint256) public pure override returns (bool) { revert("APPROVE_DISABLED"); }
    function increaseAllowance(address, uint256) public pure override returns (bool) { revert("APPROVE_DISABLED"); }
    function decreaseAllowance(address, uint256) public pure override returns (bool) { revert("APPROVE_DISABLED"); }
    function supportsInterface(bytes4 id) public view override(AccessControl) returns (bool) { return super.supportsInterface(id); }
}
