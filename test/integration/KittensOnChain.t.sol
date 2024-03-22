// SPD-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {KittensOnChain} from "../../src/KittensOnChain.sol";

contract KittensOnChainTest is Test {
    address USER = makeAddr("user");
    KittensOnChain public kittensOnChain;
    string[] public kittenURIs;

    function setUp() public returns (KittensOnChain) {
        kittenURIs = new string[](4);

        string
            memory yellowKitten = "data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4NCjxzdmcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4NCiAgICA8Y2lyY2xlIGN4PSIxMDAiIGN5PSI4MCIgcj0iNjAiIGZpbGw9IiNmNmU1OTQiIC8+DQogICAgPHBhdGggZD0ibTQwIDIwcTcwIDE4MCA2MCAyMCAyMC0zMCA1MCAxMCIgZmlsbD0iI2Y2ZTU5NCIgLz4NCiAgICA8cGF0aCBkPSJtMTYwIDIwcS03MCAxODAtNjAgMjAtMjAtMzAtNTAgMTAiIGZpbGw9IiNmNmU1OTQiIC8+DQogICAgPGNpcmNsZSBjeD0iODAiIGN5PSI3MCIgcj0iMTAiIC8+DQogICAgPGNpcmNsZSBjeD0iMTIwIiBjeT0iNzAiIHI9IjEwIiAvPg0KICAgIDxjaXJjbGUgY3g9IjEwMCIgY3k9Ijg1IiByPSI1IiAvPg0KICAgIDxwYXRoIGQ9Im04MCAxMDBxMTAgMTAgMjAgMCAxMCAxMCAyMCAwIiBmaWxsPSJub25lIiBzdHJva2U9IiMwMDAiIHN0cm9rZS13aWR0aD0iNCIgLz4NCiAgICA8cGF0aCBkPSJtODAgOTBxLTQwLTEwLTUwIDAiIGZpbGw9Im5vbmUiIHN0cm9rZT0iIzAwMCIgc3Ryb2tlLXdpZHRoPSIyIiAvPg0KICAgIDxwYXRoIGQ9Im0xMjAgOTBxNDAtMTAgNTAgMCIgZmlsbD0ibm9uZSIgc3Ryb2tlPSIjMDAwIiBzdHJva2Utd2lkdGg9IjIiIC8+DQo8L3N2Zz4=";
        string
            memory redKitten = "data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4NCjxzdmcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4NCiAgICA8Y2lyY2xlIGN4PSIxMDAiIGN5PSI4MCIgcj0iNjAiIGZpbGw9IiNmNjg1ODUiIC8+DQogICAgPHBhdGggZD0ibTQwIDIwcTcwIDE4MCA2MCAyMCAyMC0zMCA1MCAxMCIgZmlsbD0iI2Y2ODU4NSIgLz4NCiAgICA8cGF0aCBkPSJtMTYwIDIwcS03MCAxODAtNjAgMjAtMjAtMzAtNTAgMTAiIGZpbGw9IiNmNjg1ODUiIC8+DQogICAgPGNpcmNsZSBjeD0iODAiIGN5PSI3MCIgcj0iMTAiIC8+DQogICAgPGNpcmNsZSBjeD0iMTIwIiBjeT0iNzAiIHI9IjEwIiAvPg0KICAgIDxjaXJjbGUgY3g9IjEwMCIgY3k9Ijg1IiByPSI1IiAvPg0KICAgIDxwYXRoIGQ9Im04MCAxMDBxMTAgMTAgMjAgMCAxMCAxMCAyMCAwIiBmaWxsPSJub25lIiBzdHJva2U9IiMwMDAiIHN0cm9rZS13aWR0aD0iNCIgLz4NCiAgICA8cGF0aCBkPSJtODAgOTBxLTQwLTEwLTUwIDAiIGZpbGw9Im5vbmUiIHN0cm9rZT0iIzAwMCIgc3Ryb2tlLXdpZHRoPSIyIiAvPg0KICAgIDxwYXRoIGQ9Im0xMjAgOTBxNDAtMTAgNTAgMCIgZmlsbD0ibm9uZSIgc3Ryb2tlPSIjMDAwIiBzdHJva2Utd2lkdGg9IjIiIC8+DQo8L3N2Zz4=";
        string
            memory blueKitten = "data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4NCjxzdmcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4NCiAgICA8Y2lyY2xlIGN4PSIxMDAiIGN5PSI4MCIgcj0iNjAiIGZpbGw9IiM4NTk3ZjYiIC8+DQogICAgPHBhdGggZD0ibTQwIDIwcTcwIDE4MCA2MCAyMCAyMC0zMCA1MCAxMCIgZmlsbD0iIzg1OTdmNiIgLz4NCiAgICA8cGF0aCBkPSJtMTYwIDIwcS03MCAxODAtNjAgMjAtMjAtMzAtNTAgMTAiIGZpbGw9IiM4NTk3ZjYiIC8+DQogICAgPGNpcmNsZSBjeD0iODAiIGN5PSI3MCIgcj0iMTAiIC8+DQogICAgPGNpcmNsZSBjeD0iMTIwIiBjeT0iNzAiIHI9IjEwIiAvPg0KICAgIDxjaXJjbGUgY3g9IjEwMCIgY3k9Ijg1IiByPSI1IiAvPg0KICAgIDxwYXRoIGQ9Im04MCAxMDBxMTAgMTAgMjAgMCAxMCAxMCAyMCAwIiBmaWxsPSJub25lIiBzdHJva2U9IiMwMDAiIHN0cm9rZS13aWR0aD0iNCIgLz4NCiAgICA8cGF0aCBkPSJtODAgOTBxLTQwLTEwLTUwIDAiIGZpbGw9Im5vbmUiIHN0cm9rZT0iIzAwMCIgc3Ryb2tlLXdpZHRoPSIyIiAvPg0KICAgIDxwYXRoIGQ9Im0xMjAgOTBxNDAtMTAgNTAgMCIgZmlsbD0ibm9uZSIgc3Ryb2tlPSIjMDAwIiBzdHJva2Utd2lkdGg9IjIiIC8+DQo8L3N2Zz4=";
        string
            memory greenKitten = "data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4NCjxzdmcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4NCiAgICA8Y2lyY2xlIGN4PSIxMDAiIGN5PSI4MCIgcj0iNjAiIGZpbGw9IiM4NWY2OTQiIC8+DQogICAgPHBhdGggZD0ibTQwIDIwcTcwIDE4MCA2MCAyMCAyMC0zMCA1MCAxMCIgZmlsbD0iIzg1ZjY5NCIgLz4NCiAgICA8cGF0aCBkPSJtMTYwIDIwcS03MCAxODAtNjAgMjAtMjAtMzAtNTAgMTAiIGZpbGw9IiM4NWY2OTQiIC8+DQogICAgPGNpcmNsZSBjeD0iODAiIGN5PSI3MCIgcj0iMTAiIC8+DQogICAgPGNpcmNsZSBjeD0iMTIwIiBjeT0iNzAiIHI9IjEwIiAvPg0KICAgIDxjaXJjbGUgY3g9IjEwMCIgY3k9Ijg1IiByPSI1IiAvPg0KICAgIDxwYXRoIGQ9Im04MCAxMDBxMTAgMTAgMjAgMCAxMCAxMCAyMCAwIiBmaWxsPSJub25lIiBzdHJva2U9IiMwMDAiIHN0cm9rZS13aWR0aD0iNCIgLz4NCiAgICA8cGF0aCBkPSJtODAgOTBxLTQwLTEwLTUwIDAiIGZpbGw9Im5vbmUiIHN0cm9rZT0iIzAwMCIgc3Ryb2tlLXdpZHRoPSIyIiAvPg0KICAgIDxwYXRoIGQ9Im0xMjAgOTBxNDAtMTAgNTAgMCIgZmlsbD0ibm9uZSIgc3Ryb2tlPSIjMDAwIiBzdHJva2Utd2lkdGg9IjIiIC8+DQo8L3N2Zz4=";

        kittenURIs[0] = yellowKitten;
        kittenURIs[1] = redKitten;
        kittenURIs[2] = blueKitten;
        kittenURIs[3] = greenKitten;

        vm.startBroadcast();
        kittensOnChain = new KittensOnChain(kittenURIs);
        vm.stopBroadcast();
        return kittensOnChain;
    }

    function testMintNft() public {
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

    function testRetrieveNonExistingToken() public {
        vm.expectRevert();
        kittensOnChain.tokenURI(0);

        vm.prank(USER);
        kittensOnChain.mintNft();

        vm.expectRevert();
        kittensOnChain.tokenURI(1);
    }

    function testChangeColor() public {
        vm.prank(USER);
        kittensOnChain.mintNft();
        uint256 tokenId = kittensOnChain.getTokenCounter() - 1;

        vm.prank(USER);
        kittensOnChain.changeColor(tokenId);

        KittensOnChain.ColorTrait updatedColorTrait = kittensOnChain
            .getStateOfToken(tokenId);

        assert(updatedColorTrait == KittensOnChain.ColorTrait.RED);
    }

    function testChangeColorAccessControl() public {
        vm.prank(USER);
        kittensOnChain.mintNft();
        uint256 tokenId = kittensOnChain.getTokenCounter() - 1;

        vm.expectRevert();
        kittensOnChain.changeColor(tokenId); // The address calling this function is not USER, it's address(this)
    }

    function testViewTokenUri() public {
        vm.prank(USER);
        kittensOnChain.mintNft();
        console.log(kittensOnChain.tokenURI(0));
    }

    function testGetYellowKitten() public view {
        string memory expectedUri = kittenURIs[0];
        string memory actualUri = kittensOnChain.getYellowKitten();
        assert(
            keccak256(abi.encodePacked(actualUri)) ==
                keccak256(abi.encodePacked(expectedUri))
        );
    }

    function testGetRedKitten() public view {
        string memory expectedUri = kittenURIs[1];
        string memory actualUri = kittensOnChain.getRedKitten();
        assert(
            keccak256(abi.encodePacked(actualUri)) ==
                keccak256(abi.encodePacked(expectedUri))
        );
    }

    function testGetBlueKitten() public view {
        string memory expectedUri = kittenURIs[2];
        string memory actualUri = kittensOnChain.getBlueKitten();
        assert(
            keccak256(abi.encodePacked(actualUri)) ==
                keccak256(abi.encodePacked(expectedUri))
        );
    }

    function testGetGreenKitten() public view {
        string memory expectedUri = kittenURIs[3];
        string memory actualUri = kittensOnChain.getGreenKitten();
        assert(
            keccak256(abi.encodePacked(actualUri)) ==
                keccak256(abi.encodePacked(expectedUri))
        );
    }
}
