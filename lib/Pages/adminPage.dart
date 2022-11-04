import 'package:block_chain_in_judicial_system/river_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'commonwidgets.dart';

class AdminPage extends ConsumerWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    dec(String lbl, TextEditingController c) => TextField(
        controller: c,
        decoration: InputDecoration(
          label: Text(
            lbl,
            style: TextStyle(color: Colors.white),
          ),
        ));

    TextEditingController jc = TextEditingController();
    TextEditingController lc = TextEditingController();

    TextEditingController pc = TextEditingController();

    return Scaffold(
      appBar: appbar("Admin", ref.watch(curUser), context, ref),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //adding judge

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 300, child: dec("Judge Address", jc)),
              const SizedBox(
                width: 50,
              ),
              ElevatedButton(
                  onPressed: () {
                    ref
                        .watch(contractProvider)
                        .addJudge(jc.value.text.toString())
                        .then((value) => Alert(
                              context: context,
                              title: "Judge address successfully added",
                            ).show())
                        .onError((error, stackTrace) => Alert(
                                context: context,
                                title: "Failed to add Judge address",
                                desc: error.toString())
                            .show());
                  },
                  child: const Text("Add Judge"))
            ],
          ),
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 300, child: dec("Lawyer Address", lc)),
              const SizedBox(
                width: 50,
              ),
              ElevatedButton(
                  onPressed: () {
                    ref
                        .watch(contractProvider)
                        .addLawyer(lc.value.text.toString())
                        .then((value) => Alert(
                              context: context,
                              title: "Lawyer address successfully added",
                            ).show())
                        .onError((error, stackTrace) => Alert(
                                context: context,
                                title: "Failed to add Lawyer address",
                                desc: error.toString())
                            .show());
                            lc.clear();
                  },
                  child: const Text("Add Lawyer"))

            ],
          ),
          const SizedBox(
            height: 50,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 300, child: dec("Police Address", pc)),
              const SizedBox(
                width: 50,
              ),
              ElevatedButton(
                  onPressed: () {
                    print(pc.value.text);
                    ref
                        .watch(contractProvider)
                        .addPolice(pc.value.text.toString())
                        .then((value) => Alert(
                              context: context,
                              title: "Police address successfully added",
                            ).show())
                        .onError((error, stackTrace) => Alert(
                                context: context,
                                title: "Failed to add Police address",
                                desc: error.toString())
                            .show());
                            pc.clear();
                  },
                  child: const Text("Add Police"))
            ],
          )

          //adding police

          //adding lawyer
        ],
      ),
    );
  }
}
