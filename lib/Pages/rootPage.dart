import 'package:block_chain_in_judicial_system/Pages/PLJpage.dart';
import 'package:block_chain_in_judicial_system/Pages/adminPage.dart';
import 'package:block_chain_in_judicial_system/Pages/unknownPage.dart';
import 'package:block_chain_in_judicial_system/river_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RootPage extends ConsumerWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contractRef = ref.watch(contractProvider);
    // final curTypeOfUser = ref.watch(currentUserTypeProvider);
    return FutureBuilder(
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return FutureBuilder(
              builder: ((context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("Error here ${snapshot.error}"));
                } else if (snapshot.connectionState == ConnectionState.done) {
                  String? data = snapshot.data;
                  print(data);
                 // ref.watch(cUserType.notifier).state = data!;
                  if (data == "Admin") {
                    //Admin page
                    return const AdminPage();
                  } else if (data == "Unknown") {
                    //  Unknown page
                    return const UnKnownPage();
                  } else {
                    //Lawyer policejudge page
                    return  PLJpage(data!);
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
              future: contractRef.typeofUser(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("failed to load user typ : ${snapshot.error}"),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        } else if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text("Failed to initialize contract"),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
      future: contractRef.initialize(),
    );
  }
}
