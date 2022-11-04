import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web3/ethers.dart' ;
import 'package:flutter_web3/flutter_web3.dart' as fweb;
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class Judicial {
  final String _rpcUrl = "HTTP://127.0.0.1:8545";
  String? abiCode;
  EthereumAddress? contractAddress;
  Credentials? credential;
  DeployedContract? judContract;
  Web3Client? client;
  // Web3Connect w3c = Web3Connection();

  Future<void> initalize() async {
    String abiStringFile = await rootBundle.loadString("assets/Judicial.json");
    var jsonAbi = jsonDecode(abiStringFile);
    abiCode = jsonEncode(jsonAbi['abi']);
    contractAddress =
        EthereumAddress.fromHex(jsonAbi["networks"]["5777"]["address"]);

    // print(abiCode);
    // print(contractAddress);

    judContract = DeployedContract(
      ContractAbi.fromJson(abiCode!, "Judicial"),
      contractAddress!,
    );

//     String content = File("wallet.json").readAsStringSync();
// Wallet wallet = Wallet.fromJson(content, "testpassword");

// Credentials unlocked = wallet.privateKey;

    // client = Web3Client(_rpcUrl, Client());

    // credential = EthPrivateKey.fromHex(
    //     "465eb88277df1aaae301f3da4fd4370cbd84f575fd40634e2e4ce50d579b935c");

    // print((await credential!.extractAddress()).hex);

    // client!
    //     .sendTransaction(
    //         credential!,
    //         Transaction.callContract(
    //             contract: judContract!,
    //             function: judContract!.function("closeCase"),
    //             parameters: [
    // BigInt.from(2),
    // "Fucking do it"
    //             ]))
    //     .then((value) => print("Value received : ${value.toString()}"))
    //     .onError((error, stackTrace) =>
    //         print("Try something else \n" + error.toString()));
    // print(provider)

    // Credentials credentisl=Credentials
    // print(_contract.functions);

    // final rpcProvider = JsonRpcProvider(_rpcUrl);
    // final web3provider = Web3Provider.fromEthereum(ethereum!);
    //rpcProvider.
//

//recent





    final anotherBusd = Contract(
      contractAddress.toString(),
      Interface(abiCode),
      provider!.getSigner(),
    );

    // // anotherBusd.
    // //getTotalCases
    // print("\n\n\n\n");

    anotherBusd
        .call(
          "isLawyer",
         //["0x7aC1B3d376000073Ebf172cf766EC4b2fD29a165"],
          // [
          //   [BigInt.from(2), "Fucking do it","fuck "]
          // ],
        )
        .then((value) => print("For god sake done $value"))
        .onError((error, stackTrace) =>
            print("Try something else \n" + error.toString()));



    //recent

    // final tx =await anotherBusd
    //     .send("addLawyer", [
    //       [
    // EthereumAddress.fromHex(
    //     '0xc825432ffb3d6C08536cf0c09425538AB40C9F53',enforceEip55 : true),
    //       ],
    //       TransactionOverride(value: BigInt.from(100000000)),
    //     ]);
//
    // tx.hash;

    // var res=tx.wait();

    // print(tx);

    // .then((value) => print(value))
    // .onError(
    //   (error, stackTrace) => print("Fucking Error " + error.toString()),
    // );

    // tx.wait();

    // Web3Client client = Web3Client(_rpcUrl, Client());

    // Credentials? _credentials = await EthPrivateKey.fromHex(
    //     "8916f8bf0be3e6c3848007bc799c07fb0b2b9bcf964bf2979c4ced5cccf70d14");

    // client
    //     .call(
    //       sender: EthereumAddress.fromHex("0x7569dF01489E714ad11f4E88ce2CBe49fB070186"),
    //         contract: _contract,
    //         function: _contract.function("getTotalCases"),
    //         params: [])
    //     .then((value) => print(value))
    //     .onError((error, stackTrace) => print(error));

    //
  }
}
