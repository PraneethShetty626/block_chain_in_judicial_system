import 'dart:convert';

import 'package:block_chain_in_judicial_system/ethcontract/Judicial.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Data extends ChangeNotifier {
  List<Case> casesList = [];
  Judicial judicial;
  Data(this.judicial);

  Future<List<Case>?> getData() async {
    try {
      List<dynamic> res = await judicial.getAllCases();

      res.forEach((element) {
        // for(int i=0;i<14;i++){
        //   print(element[i].runtimeType);
        // }

        Case cases = Case(
          jsonDecode(element[0].toString()),
          element[1] ?? "No title",
          element[2] ?? "no description",
          (element[3]).cast<String>(),
          // [],
          (element[4]).cast<String>(),
          // [],
          (element[5]),
          (element[6]) ?? "No defendent lawyer",
          (element[7]) ?? "No plantiff lawyer",
          (element[8]) ?? "Till not judged",
          (element[9]),
          (element[10]) ?? "No judgement yet",
          (element[11]).cast<String>(),
          (element[12]).cast<String>(),

          jsonDecode(element[13].toString()),
        );
        casesList.add(cases);
      });
      return casesList;
    } catch (e) {
      print(e.toString());
    }
  }
}
