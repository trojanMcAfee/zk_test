// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;

import {Script} from "forge-std/Script.sol";
// import {Counter} from "./../src/Counter.sol";
import {Verifier} from "../zk/Verifier.sol";
// import {Verifier2} from "../zk/Verifier2.sol";
import {Verifier2} from "./../zk/Verifier2.sol";
import {console} from "./../lib/forge-std/src/console.sol";

import "../lib/forge-std/src/StdJson.sol";


contract CounterScript is Script {

    using stdJson for string;

    struct RootStruct {
        string curve;
        uint[2] pi_a;
        uint[2][2] pi_b;
        uint[2] pi_c;
        string protocol;
    }

    function run2() external { 
        uint deployerKey = vm.envUint("PRIVATE_KEY");

        string memory root = vm.projectRoot();
        string memory path = string.concat(root, "/zk/proof.json");
        string memory json = vm.readFile(path);
        bytes memory data = vm.parseJson(json);
        // console.logBytes(data);

        RootStruct memory rootStruct = abi.decode(data, (RootStruct));

        path = string.concat(root, "/zk/public.json");
        json = vm.readFile(path);
        data = vm.parseJson(json);
        uint[1] memory signal = abi.decode(data, (uint[1]));

        vm.startBroadcast(deployerKey);

        Verifier2 verifier2 = new Verifier2();
        bool isProof = verifier2.verifyProof(rootStruct.pi_a, rootStruct.pi_b, rootStruct.pi_c, signal);

        console.log('is - true: ', isProof);
        console.log('rootStruct.pi_a[0]: ', rootStruct.pi_a[0]);

        vm.stopBroadcast();
    }

    

    function run() external { 
        // vm.createSelectFork(vm.rpcUrl("ethereum"), 20021131);
        uint deployerKey = vm.envUint("PRIVATE_KEY");

        // string memory root = vm.projectRoot();
        // string memory path = string.concat(root, "/zk/proof.json");
        // string memory json = vm.readFile(path);
        // bytes memory data = vm.parseJson(json);

        // console.log(0);
        // RootStruct memory rootStruct = abi.decode(data, (RootStruct));
        // console.log(11);

        // path = string.concat(root, "/zk/public.json");
        // json = vm.readFile(path);
        // data = vm.parseJson(json);
        // uint[1] memory signal = abi.decode(data, (uint[1]));

        // // uint[1] memory input = [uint(rootStruct.inputs[0])];
        // bool isProof;

        vm.startBroadcast(deployerKey);


        uint[2] memory a = [0x0603b10c5a63402f3bf5d882fc448e07b48ce3fc5b0d7cb8f66dec453a041440, 0x2ecd7b96ab070a3423a4cc8118e5c8023def931ddef743ed58e71788f4eafaf6];
        uint[2][2] memory b = [[0x2f8df79cc70e0b9f4cfd9c2c4ff52efc32c2d783a94eaedef0d7d908d0f241ee, 0x01be31ad933394dd91c3e757e6496139538c43115425ff0596287ea4d8b7afed],[0x293277d9721779eec31e0cfcff09f2c22f8f46d44e0001910b3c2b43a3afd8f3, 0x13f5f6ed375c958f15119371c201cb37531eaa801d4f4b92120a8aa2c39a351a]];
        uint[2] memory c = [0x0c574cad70264bb214423cf00cc112e0d2de6c5e7f9119dc672b765bff58431a, 0x19c5246070e29769bb6883a142ce225b8b2e37d4ebad4e8029c85d8844fc6619];
        uint[1] memory signal = [uint(0x0000000000000000000000000000000000000000000000000000000000000021)];

        Verifier2 verifier2 = new Verifier2();
        bool isProof = verifier2.verifyProof(a, b, c, signal);

        console.log('is - true: ', isProof);

        vm.stopBroadcast();
    }


}
