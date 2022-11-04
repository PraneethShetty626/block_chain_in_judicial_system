import 'package:block_chain_in_judicial_system/Pages/commonwidgets.dart';
import 'package:block_chain_in_judicial_system/river_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UnKnownPage extends ConsumerWidget {
  const UnKnownPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: appbar("Guets user", ref.watch(curUser), context, ref),
      body: Center(
          child: ElevatedButton(
              onPressed: (() => addEvidence(context, ref)),
              child: const Text("Add evidence"))),
    );
  }
}
