import 'package:block_chain_in_judicial_system/ethcontract/Judicial.dart';
import 'package:block_chain_in_judicial_system/ipfs/ipfs.dart';
import 'package:block_chain_in_judicial_system/river_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

Card caseCard(Case case1) {
  return Card(
    margin: EdgeInsets.symmetric(horizontal: 100, vertical: 30),
    child: Container(
      height: 500,
      width: 1000,
      margin: const EdgeInsets.all(30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Case no : ${case1.caseno}"),
              Text("Case Title : ${case1.title}"),
              Text("Case description : ${case1.description}"),
              Text("Filed by : ${case1.filedby}"),
              Text(
                  "Defendents : ${case1.defendents.toString().split("[")[1].split("]")[0]}"),
              Text(
                  "Plantiffs : ${case1.plantiffs.toString().split("[")[1].split("]")[0]}"),
              Text("Defendent Lawyer : ${case1.defendentLawyer}"),
              Text("Plantiff Lawyer : ${case1.plantiffLawyer}"),
              Text("Judge : ${case1.hearingJudge}"),
              Text("Completed : ${case1.completed}"),
              Text("Judgement : ${case1.judgement}"),
              Text("Total Evidences : ${case1.evidenceCount}"),
            ],
          ),
          SizedBox(
            width: 300,
            height: 500,

            // height: 200,
            child: ListView.builder(
                itemCount: case1.evidenceCount,
                itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(30),
                      child: ElevatedButton(
                          onPressed: () {
                            IPFS().readFile(context,case1.evidenceNames[index],case1.evidenceAddress[index]);
                          },
                          child: Text(case1.evidenceNames[index])),
                    )),
          )
        ],
      ),
    ),
  );
}

AppBar appbar(String type, String cuser, BuildContext context, WidgetRef ref) =>
    AppBar(
      title: const Text("DEPARTMENT OF JUSTICE"),
      actions: [
        Center(child: Text("$type : $cuser")),
        const SizedBox(
          width: 50,
        ),
        TextButton.icon(
          onPressed: () {
            addEvidence(context, ref);
          },
          label: const Text(
            "Submit evidences",
            style: TextStyle(color: Colors.white),
          ),
          icon: const Icon(
            Icons.add_box_sharp,
            color: Colors.white,
          ),
        )
      ],
    );

dec(String name) => InputDecoration(
    label: Text(name, style: const TextStyle(color: Colors.white)));

Future<void> addEvidence(BuildContext context, WidgetRef ref) async {
  int? caseno;
  String? name;
  final ameC = GlobalKey<FormState>();
  showDialog(
    builder: (context) {
      return AlertDialog(
        title: const Text("Upload Document"),
        content: Form(
          key: ameC,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 400,
                child: TextFormField(
                  validator: ((value) =>
                      int.parse(value!) < 0 ? "Invalid number" : null),
                  onSaved: ((newValue) => caseno = int.parse(newValue!)),
                  decoration: dec("Case number"),
                  maxLines: null,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: 400,
                child: TextFormField(
                  validator: ((value) =>
                      value!.isEmpty ? "Enter a name" : null),
                  onSaved: ((newValue) => name = newValue!),
                  decoration: dec("title of evidence"),
                  maxLines: null,
                ),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () {
                  if (ameC.currentState!.validate()) {
                    ameC.currentState!.save();

                    IPFS().pickAndUploadfile().then((value) {
                      print(value);
                      ref
                          .watch(contractProvider)
                          .uploadEvidence(caseno!, name!, value.toString())
                          .then((value) => Alert(
                                context: context,
                                title: "Evidence successfulyy uploaded",
                              ).show())
                          .onError((error, stackTrace) => Alert(
                                  context: context,
                                  title: "Failed to upload evidence",
                                  desc: error.toString())
                              .show())
                          .then((value) => Navigator.of(context).pop());
                    }).onError((error, stackTrace) {
                      Alert(
                              context: context,
                              title: "Failed to upload evidence",
                              desc: error.toString())
                          .show();
                    });
                    // ref.watch(contractProvider).uploadEvidence(caseno!, name!, )
                  }
                },
                child: const Text("Select & Upload the document")),
          )
        ],
      );
    },
    context: context,
  );
}

Future<void> createCase(BuildContext context, WidgetRef ref) async {
  String? title, description, defendents, plantiffs;

  final formcontroller = GlobalKey<FormState>();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Create new Case"),
      content: SizedBox(
        width: 500,
        child: Form(
            key: formcontroller,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    validator: ((value) =>
                        value!.isEmpty ? "Enter a valid title" : null),
                    onSaved: ((newValue) => title = newValue!),
                    decoration: dec("Title"),
                    maxLines: null,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: ((value) =>
                        value!.isEmpty ? "Enter a valid description" : null),
                    onSaved: ((newValue) => description = newValue!),
                    decoration: dec("Description"),
                    maxLines: null,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: ((value) => value!.isEmpty
                        ? "Enter a valid defendents name"
                        : null),
                    onSaved: ((newValue) => defendents = newValue!),
                    decoration: dec("Defendents"),
                    maxLines: null,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: ((value) =>
                        value!.isEmpty ? "Enter a valid plantiffs name" : null),
                    onSaved: ((newValue) => plantiffs = newValue!),
                    decoration: dec("Plantiffs"),
                    maxLines: null,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            )),
      ),
      actions: [
        FloatingActionButton.extended(
            onPressed: () async {
              if (formcontroller.currentState!.validate()) {
                formcontroller.currentState!.save();

                ref
                    .watch(contractProvider)
                    .createCase(
                        title!, description!, [defendents!], [plantiffs!])
                    .then((value) => Alert(
                            context: context,
                            title: "New Case successfully created")
                        .show())
                    .onError((error, stackTrace) => Alert(
                            context: context,
                            title: "Failed to create new case",
                            desc: error.toString())
                        .show())
                    .then((value) => Navigator.of(context).pop());

                formcontroller.currentState!.reset();
              }
              // ref.watch(contractProvider).createCase(title, description, defendents, plantiffs)
            },
            label: const Text("Confirm"))
      ],
    ),
  );
}

Future<void> addLawyer(
  BuildContext context,
  WidgetRef ref,
  String type,
) async {
  int? caseno;
  String? address;
  final formkey = GlobalKey<FormState>();
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Enter the address of $type"),
        content: Form(
          key: formkey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 300,
                child: TextFormField(
                  validator: (value) => int.tryParse(value.toString())! < 0
                      ? "Invalid number"
                      : null,
                  onSaved: (newValue) => caseno = int.tryParse(newValue!)!,
                  maxLines: null,
                  decoration: dec("Case number"),
                ),
              ),
              SizedBox(
                width: 300,
                child: TextFormField(
                  validator: (value) => type != "caseclose"
                      ? value!.length >= 40 && value.length <= 42
                          ? null
                          : "Invalid address"
                      : value!.isNotEmpty
                          ? null
                          : "Invalid judgement",
                  onSaved: (newValue) => address = newValue!,
                  decoration:
                      dec(type != "caseclose" ? "Lawyer address" : "Judgement"),
                  maxLines: null,
                ),
              ),
            ],
          ),
        ),
        actions: [
          FloatingActionButton.extended(
              onPressed: () async {
                final cp = ref.watch(contractProvider);
                if (formkey.currentState!.validate()) {
                  formkey.currentState!.save();

                  try {
                    if (type == "registerPlantifflawyer") {
                      await cp.registerPlantifflawyer(caseno!, address!);
                    } else if (type == "registerDefendentLawyer") {
                      await cp.registerDefendentLawyer(caseno!, address!);
                    } else {
                      await cp.closeCase(caseno!, address!);
                    }
                    formkey.currentState!.reset();
                    Alert(
                            context: context,
                            title: type != "caseclose"
                                ? "Lawyer successfully assigned"
                                : "Case successfully closed")
                        .show()
                        .then((value) => Navigator.of(context).pop());
                  } catch (e) {
                    Alert(
                            context: context,
                            title: type != "caseclose"
                                ? "Failed to add Lawyer"
                                : "Faild to close case",
                            desc: e.toString())
                        .show()
                        .then((value) => Navigator.of(context).pop());
                  }
                }
              },
              label: const Text("Confirm"))
        ],
      );
    },
  );
}
