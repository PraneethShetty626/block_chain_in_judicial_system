import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web3/flutter_web3.dart';

import 'package:web3dart/web3dart.dart' as web3;

class Case {
  int caseno;
  String title;
  String description;
  List<String> defendents;
  List<String> plantiffs;
  String filedby;
  String defendentLawyer;
  String plantiffLawyer;
  String hearingJudge;
  bool completed;
  String judgement;
  List<String> evidenceNames;
  List<String> evidenceAddress;
  int evidenceCount;

  Case(
      this.caseno,
      this.title,
      this.description,
      this.defendents,
      this.plantiffs,
      this.filedby,
      this.defendentLawyer,
      this.plantiffLawyer,
      this.hearingJudge,
      this.completed,
      this.judgement,
      this.evidenceNames,
      this.evidenceAddress,
      this.evidenceCount);
}

class Judicial extends ChangeNotifier {
  final String rpcUrl = "HTTP://127.0.0.1:8545";
  Contract? finalcontract;

  //initializing the contract

  Future<Judicial> initialize() async {
    String abiStringFile = await rootBundle.loadString("assets/Judicial.json");
    var jsonAbi = jsonDecode(abiStringFile);
    String abiCode = jsonEncode(jsonAbi["abi"]);
    web3.EthereumAddress? contractAddress = web3.EthereumAddress.fromHex(
      jsonAbi["networks"]["5777"]["address"],
    );
    finalcontract = Contract(
      contractAddress.toString(),
      Interface(abiCode),
      provider!.getSigner(),
    );
    return this;
  }

  //Determining the type of user

  Future<String?> typeofUser() async {
    
    if (await finalcontract!.call("isPolice")) {
      return "Police";
    } else if (await finalcontract!.call("isLawyer")) {
      return "Lawyer";
    } else if (await finalcontract!.call("isJudge")) {
      return "Judge";
    } else if (await finalcontract!.call("isadmin")) {
      return "Admin";
    } else {
      return "Unknown";
    }
  }

  //adding judge to system

  Future<TransactionResponse> addJudge(String address) async {
    return await finalcontract!.send("addJudge", [address]);
  }

  //addPolice

  Future<TransactionResponse> addLawyer(String address) async {
    return await finalcontract!.send("addLawyer", [address]);
  }

  //addPolice

  Future<TransactionResponse> addPolice(String address) async {
    return await finalcontract!.send("addPolice", [address]);
  }

  //createCase
  Future<TransactionResponse> createCase(
    String title,
    String description,
    List<String> defendents,
    List<String> plantiffs,
  ) async {
    return await finalcontract!.send(
      "createCase",
      [
        title,
        description,
        defendents,
        plantiffs,
      ],
    );
  }

  //register defendentlawyer
  Future<TransactionResponse> registerDefendentLawyer(
      int caseno, String address) async {
    return await finalcontract!.send(
      "registerDefendentLawyer",
      [caseno, address],
    );
  }

  //register plantiff lawyer

  Future<TransactionResponse> registerPlantifflawyer(
      int caseno, String address) async {
    return await finalcontract!.send(
      "registerPlantifflawyer",
      [caseno, address],
    );
  }

  //upload evidence
  Future<TransactionResponse> uploadEvidence(
      int caseno, String name, String address) async {
    return await finalcontract!.send(
      "uploadEvidence",
      [caseno, name, address],
    );
  }

  //closeCase
  Future<TransactionResponse> closeCase(int caseno, String judgement) async {
    return await finalcontract!.send(
      "closeCase",
      [caseno, judgement],
    );
  }

  Future<dynamic> totalCases() async {
    return await finalcontract!.call(
      "getTotalCases",
    );
  }

  Future<List<dynamic>> getAllCases() async {
    return await finalcontract!.call(
      "getAllCases",
    );
  }
}
