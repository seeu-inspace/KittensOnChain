// SPD-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {KittensOnChain} from "../../src/KittensOnChain.sol";
import {DeployKittensOnChain} from "../../script/DeployKittensOnChain.s.sol";

contract KittensOnChainIntegrationTest is Test {
    address USER = makeAddr("user");
    KittensOnChain public kittensOnChain;
    DeployKittensOnChain public deployer;

    function setUp() public {
        deployer = new DeployKittensOnChain();
        kittensOnChain = deployer.run();
    }

    function testMintNftIntegration() public {
        // Test for token counter increase
        uint256 initialTokenCounter = kittensOnChain.getTokenCounter();

        vm.prank(USER);
        kittensOnChain.mintNft();

        assert(kittensOnChain.getTokenCounter() == initialTokenCounter + 1);

        // Test for correct owner of the token
        uint256 tokenId = initialTokenCounter;

        address owner = kittensOnChain.ownerOf(tokenId);
        assert(owner == USER);

        // Test for correct color
        KittensOnChain.ColorTrait updatedColorTrait = kittensOnChain
            .getStateOfToken(tokenId);

        assert(updatedColorTrait == KittensOnChain.ColorTrait.YELLOW);
    }

    function testRetrieveNonExistingTokenIntegration() public {
        vm.expectRevert();
        kittensOnChain.tokenURI(0);

        vm.prank(USER);
        kittensOnChain.mintNft();

        vm.expectRevert();
        kittensOnChain.tokenURI(1);
    }

    function testChangeColorIntegration() public {
        vm.prank(USER);
        kittensOnChain.mintNft();
        uint256 tokenId = kittensOnChain.getTokenCounter() - 1;

        vm.prank(USER);
        kittensOnChain.changeColor(tokenId);

        KittensOnChain.ColorTrait updatedColorTrait = kittensOnChain
            .getStateOfToken(tokenId);

        assert(updatedColorTrait == KittensOnChain.ColorTrait.RED);
    }

    function testChangeColorAccessControlIntegration() public {
        vm.prank(USER);
        kittensOnChain.mintNft();
        uint256 tokenId = kittensOnChain.getTokenCounter() - 1;

        vm.expectRevert();
        kittensOnChain.changeColor(tokenId); // The address calling this function is not USER, it's address(this)
    }

    function testViewTokenUriIntegration() public {
        vm.prank(USER);
        kittensOnChain.mintNft();
        console.log(kittensOnChain.tokenURI(0));
    }
}
