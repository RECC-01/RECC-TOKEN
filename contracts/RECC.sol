// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
    Reserve Economy Crypto Coin (RECC)

    - Fixed supply: 100,000,000 RECC
    - Decimals: 18
    - No minting
    - No burning
    - No admin
    - No owner
    - Store-of-value asset (Bitcoin-inspired)

    Network: RECC-01 / EVM Compatible
    Author: RECCNETWORK Blockchain Ecosystem
*/

contract RECC {

    /* =============================================================
                                METADATA
    ============================================================= */

    string public constant name = "Reserve Economy Crypto Coin";
    string public constant symbol = "RECC";
    uint8  public constant decimals = 18;

    uint256 public constant totalSupply =
        100_000_000 * 10 ** uint256(decimals);

    /* =============================================================
                            ERC20 STORAGE
    ============================================================= */

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    /* =============================================================
                                EVENTS
    ============================================================= */

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /* =============================================================
                        GENESIS DISTRIBUTION
    ============================================================= */

    address public constant GENESIS_SIGNER_A =
        0x84196c3fdB7Cab79cFEf56465c593322fa3B03e3;

    address public constant GENESIS_SIGNER_B =
        0xa8529d84646C9e2eFc8F74b3475BeEFDbCb3D6aC;

    /* =============================================================
                              CONSTRUCTOR
    ============================================================= */

    constructor() {
        uint256 supplyA = 21_000_000 * 10 ** uint256(decimals);
        uint256 supplyB = 79_000_000 * 10 ** uint256(decimals);

        balanceOf[GENESIS_SIGNER_A] = supplyA;
        balanceOf[GENESIS_SIGNER_B] = supplyB;

        emit Transfer(address(0), GENESIS_SIGNER_A, supplyA);
        emit Transfer(address(0), GENESIS_SIGNER_B, supplyB);
    }

    /* =============================================================
                          ERC20 CORE LOGIC
    ============================================================= */

    function transfer(address to, uint256 value) external returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    function approve(address spender, uint256 value) external returns (bool) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool) {
        uint256 allowed = allowance[from][msg.sender];
        require(allowed >= value, "RECC: allowance exceeded");

        allowance[from][msg.sender] = allowed - value;
        _transfer(from, to, value);
        return true;
    }

    /* =============================================================
                            INTERNAL
    ============================================================= */

    function _transfer(
        address from,
        address to,
        uint256 value
    ) internal {
        require(to != address(0), "RECC: transfer to zero");
        require(balanceOf[from] >= value, "RECC: balance too low");

        balanceOf[from] -= value;
        balanceOf[to]   += value;

        emit Transfer(from, to, value);
    }
}
