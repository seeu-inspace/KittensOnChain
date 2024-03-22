// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {KittensOnChain} from "../src/KittensOnChain.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

/**
 * @title DeployKittensOnChain
 * @dev Contract for deploying the KittensOnChain contract with predefined SVG images.
 */
contract DeployKittensOnChain is Script {
    uint256 public DEFAULT_ANVIL_PRIVATE_KEY =
        0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
    uint256 public deployerKey;

    /**
     * @dev Runs the script to deploy the KittensOnChain contract.
     * @return Deployed KittensOnChain contract.
     */
    function run() external returns (KittensOnChain) {
        if (block.chainid == 31337) {
            deployerKey = DEFAULT_ANVIL_PRIVATE_KEY;
        } else {
            deployerKey = vm.envUint("PRIVATE_KEY");
        }

        string[] memory kittenURIs = new string[](4);

        string memory yellowKitten = vm.readFile("./img/yellow_kitten.svg");
        string memory redKitten = vm.readFile("./img/red_kitten.svg");
        string memory blueKitten = vm.readFile("./img/blue_kitten.svg");
        string memory greenKitten = vm.readFile("./img/green_kitten.svg");

        kittenURIs[0] = svgToImageURI(yellowKitten);
        kittenURIs[1] = svgToImageURI(redKitten);
        kittenURIs[2] = svgToImageURI(blueKitten);
        kittenURIs[3] = svgToImageURI(greenKitten);

        vm.startBroadcast();
        KittensOnChain kittensOnChain = new KittensOnChain(kittenURIs);
        vm.stopBroadcast();
        return kittensOnChain;
    }

    /**
     * @dev Converts SVG string to image URI.
     * @param svg SVG string to convert.
     * @return Image URI.
     */
    function svgToImageURI(
        string memory svg
    ) public pure returns (string memory) {
        string memory baseURI = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(
            bytes(string(abi.encodePacked(svg)))
        );
        return string(abi.encodePacked(baseURI, svgBase64Encoded));
    }
}
