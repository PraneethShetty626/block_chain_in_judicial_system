// ignore: file_names
import 'package:block_chain_in_judicial_system/river_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../ethcontract/data.dart';
import 'commonwidgets.dart';

class PLJpage extends ConsumerWidget {
  const PLJpage(this.type, {super.key});
  final String type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cProvider = ref.watch(contractProvider);
    return Scaffold(
      appBar: appbar(type, ref.watch(curUser), context, ref),
      body: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              var casesList = snapshot.data;
              return ListView.builder(
                itemBuilder: ((context, index) {
                  return caseCard(casesList[index]);
                }),
                itemCount: casesList!.length,
              );
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        future: Data(cProvider).getData(),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton.extended(
              onPressed: () {
                createCase(context, ref);
              },
              label: const Text("Create new Case"),
            ),
            const SizedBox(
              width: 20,
            ),
            // ignore: unrelated_type_equality_checks
            (type == "Judge")
                ? FloatingActionButton.extended(
                    onPressed: (() =>
                        addLawyer(context, ref, "registerPlantifflawyer")),
                    label: const Text("Add plantiff lawyer"))
                : const SizedBox.shrink(),
            const SizedBox(
              width: 20,
            ),

            (type == "Judge")
                ? FloatingActionButton.extended(
                    onPressed: (() =>
                        addLawyer(context, ref, "registerDefendentLawyer")),
                    label: const Text("Add defendent lawyer"))
                : const SizedBox.shrink(),
            const SizedBox(
              width: 20,
            ),

            (type == "Judge")
                ? FloatingActionButton.extended(
                    onPressed: (() => addLawyer(context, ref, "caseclose")),
                    label: const Text("Close the Case"))
                : const SizedBox.shrink(),
            const SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
    );
  }
}
