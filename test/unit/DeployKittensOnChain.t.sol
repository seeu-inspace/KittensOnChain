// SPD-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {KittensOnChain} from "../../src/KittensOnChain.sol";
import {DeployKittensOnChain} from "../../script/DeployKittensOnChain.s.sol";

contract DeployKittensOnChainTest is Test {
    address USER = makeAddr("user");
    KittensOnChain public kittensOnChain;
    DeployKittensOnChain public deployer;
    string[] public kittenURIs = new string[](4);

    function setUp() public returns (KittensOnChain) {
        deployer = new DeployKittensOnChain();

        string memory yellowKitten = vm.readFile("./img/yellow_kitten.svg");
        string memory redKitten = vm.readFile("./img/red_kitten.svg");
        string memory blueKitten = vm.readFile("./img/blue_kitten.svg");
        string memory greenKitten = vm.readFile("./img/green_kitten.svg");

        kittenURIs[0] = deployer.svgToImageURI(yellowKitten);
        kittenURIs[1] = deployer.svgToImageURI(redKitten);
        kittenURIs[2] = deployer.svgToImageURI(blueKitten);
        kittenURIs[3] = deployer.svgToImageURI(greenKitten);

        vm.startBroadcast();
        kittensOnChain = new KittensOnChain(kittenURIs);
        vm.stopBroadcast();
        return kittensOnChain;
    }

    function testConvertSvgToUri() public view {
        string
            memory expectedUri = "data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxMDAiIGhlaWdodD0iNTAiIHZpZXdCb3g9IjAgMCAxMDAgNTAiPjx0ZXh0IHg9IjUwJSIgeT0iNTAlIiBkb21pbmFudC1iYXNlbGluZT0ibWlkZGxlIiB0ZXh0LWFuY2hvcj0ibWlkZGxlIiBmb250LWZhbWlseT0iQXJpYWwiIGZvbnQtc2l6ZT0iMTYiIGZpbGw9ImJsYWNrIj5UZXN0PC90ZXh0Pjwvc3ZnPg==";
        string
            memory svg = '<svg xmlns="http://www.w3.org/2000/svg" width="100" height="50" viewBox="0 0 100 50"><text x="50%" y="50%" dominant-baseline="middle" text-anchor="middle" font-family="Arial" font-size="16" fill="black">Test</text></svg>';
        string memory actualUri = deployer.svgToImageURI(svg);
        assert(
            keccak256(abi.encodePacked(actualUri)) ==
                keccak256(abi.encodePacked(expectedUri))
        );
        console.log(expectedUri);
        console.log(actualUri);
    }
}
