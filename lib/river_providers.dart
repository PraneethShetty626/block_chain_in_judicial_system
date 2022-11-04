import 'package:block_chain_in_judicial_system/ethcontract/Judicial.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final curUser = StateProvider((ref) => "");

final contractProvider = StateProvider(
  (ref) =>  Judicial(),
);

