// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

/**
 * @title KittensOnChain
 * @dev Contract for creating and managing NFTs representing kittens on chain with color traits.
 */
contract KittensOnChain is ERC721, Ownable {
    ///////////////////
    // State Variables
    ///////////////////
    uint256 private s_tokenCounter;
    string[] private s_kittenOnChainImageUris;
    mapping(uint256 => ColorTrait) private s_tokenIdToState;

    // Enum representing color traits
    enum ColorTrait {
        YELLOW,
        RED,
        BLUE,
        GREEN
    }

    ///////////////////
    // Errors
    ///////////////////
    error ERC721Metadata__URI_QueryFor_NonExistentToken();
    error KittensOnChain__CantChangeColorIfNotOwner();

    ///////////////////
    // Events
    ///////////////////
    event CreatedNFT(uint256 indexed tokenId);

    ///////////////////
    // Constructor
    ///////////////////
    /**
     * @dev Constructor to initialize the contract.
     * @param kittenOnChainImageUris Array of image URIs for different color kittens.
     */
    constructor(
        string[] memory kittenOnChainImageUris
    ) ERC721("Kitten", "KTN") Ownable(msg.sender) {
        require(
            kittenOnChainImageUris.length == 4,
            "Invalid number of image URIs"
        );

        s_tokenCounter = 0;

        s_kittenOnChainImageUris = kittenOnChainImageUris;
    }

    ///////////////////
    // Public Functions
    ///////////////////

    /**
     * @dev Mints a new NFT and assigns it to the caller.
     */
    function mintNft() public {
        uint256 tokenCounter = s_tokenCounter;
        _safeMint(msg.sender, tokenCounter);
        s_tokenCounter = s_tokenCounter + 1;
        emit CreatedNFT(tokenCounter);
    }

    /**
     * @dev Changes the color trait of the given token.
     * @param tokenId ID of the token to change color.
     */
    function changeColor(uint256 tokenId) public {
        if (
            getApproved(tokenId) != msg.sender && ownerOf(tokenId) != msg.sender
        ) {
            revert KittensOnChain__CantChangeColorIfNotOwner();
        }

        if (s_tokenIdToState[tokenId] == ColorTrait.YELLOW) {
            s_tokenIdToState[tokenId] = ColorTrait.RED;
        } else if (s_tokenIdToState[tokenId] == ColorTrait.RED) {
            s_tokenIdToState[tokenId] = ColorTrait.BLUE;
        } else if (s_tokenIdToState[tokenId] == ColorTrait.BLUE) {
            s_tokenIdToState[tokenId] = ColorTrait.GREEN;
        } else if (s_tokenIdToState[tokenId] == ColorTrait.GREEN) {
            s_tokenIdToState[tokenId] = ColorTrait.YELLOW;
        }
    }

    /**
     * @dev Returns the URI for a given token ID.
     * @param tokenId ID of the token to query.
     * @return Token URI.
     */
    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        if (ownerOf(tokenId) == address(0)) {
            revert ERC721Metadata__URI_QueryFor_NonExistentToken();
        }

        string memory imageURI = s_kittenOnChainImageUris[0];

        if (s_tokenIdToState[tokenId] == ColorTrait.RED) {
            imageURI = s_kittenOnChainImageUris[1];
        } else if (s_tokenIdToState[tokenId] == ColorTrait.BLUE) {
            imageURI = s_kittenOnChainImageUris[2];
        } else if (s_tokenIdToState[tokenId] == ColorTrait.GREEN) {
            imageURI = s_kittenOnChainImageUris[3];
        }

        return
            string(
                abi.encodePacked(
                    _baseURI(),
                    Base64.encode(
                        abi.encodePacked(
                            '{"name":"',
                            name(),
                            '", "description":"Kittens on chain", ',
                            '"attributes": [{"trait_type": "lazyness", "value": ',
                            Strings.toString(uint256(block.timestamp) % 100),
                            '}], "image":"',
                            imageURI,
                            '"}'
                        )
                    )
                )
            );
    }

    /**
     * @dev Retrieves the ColorTrait for the tokenId specified.
     */

    function getStateOfToken(uint256 tokenId) public view returns (ColorTrait) {
        return s_tokenIdToState[tokenId];
    }

    /**
     * @dev Retrieves the URI for the yellow kitten image.
     */
    function getYellowKitten() public view returns (string memory) {
        return s_kittenOnChainImageUris[0];
    }

    /**
     * @dev Retrieves the URI for the red kitten image.
     */
    function getRedKitten() public view returns (string memory) {
        return s_kittenOnChainImageUris[1];
    }

    /**
     * @dev Retrieves the URI for the blue kitten image.
     */
    function getBlueKitten() public view returns (string memory) {
        return s_kittenOnChainImageUris[2];
    }

    /**
     * @dev Retrieves the URI for the green kitten image.
     */
    function getGreenKitten() public view returns (string memory) {
        return s_kittenOnChainImageUris[3];
    }

    /**
     * @dev Retrieves the current token counter.
     */
    function getTokenCounter() public view returns (uint256) {
        return s_tokenCounter;
    }

    ///////////////////
    // Internal Functions
    ///////////////////
    /**
     * @dev Base URI for computing {tokenURI}.
     */
    function _baseURI()
        internal
        pure
        override
        returns (string memory base64URI)
    {
        return "data:application/json;base64,";
    }
}
