import 'package:block_chain_in_judicial_system/Pages/rootPage.dart';
import 'package:block_chain_in_judicial_system/river_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web3/flutter_web3.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends ConsumerState<LoginPage> {
  Future<void> initialize() async {
    List<String> cu;
    if (ethereum!.isConnected()) {
      cu = await ethereum!.getAccounts();
    } else {
      cu = await ethereum!.requestAccount();
    }
    if (cu.isNotEmpty) {
      ref.watch(curUser.notifier).state = cu[0];
    }
    ethereum!.onAccountsChanged((accounts) {
      ref.watch(curUser.notifier).state = accounts[0];
    });
  }

  @override
  WidgetRef get ref => super.ref;

  ElevatedButton connectionButton() => ElevatedButton(
        onPressed: ()async {
         var res= await ethereum!.requestAccount();
         print(res);
        },
        child:const Text("Connect accounts"),
      );

  

  @override
  Widget build(BuildContext context) {
    final cu = ref.watch(curUser);

    return Scaffold(
      body: FutureBuilder(
        future: initialize(),
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: connectionButton());
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (cu.isNotEmpty) {
              return const RootPage();
            } else {
              return Center(child: connectionButton());
            }
          }
          return const Center(child: CircularProgressIndicator());
        }),
      ),
    );

    // if (cu.isNotEmpty) {
    //   return Scaffold(
    //     body: Text(cu),
    //   );
    // } else {
    //   return  Scaffold(
    //     body: Text("Connect to wallet"),
    //   );
    // }
  }
}
