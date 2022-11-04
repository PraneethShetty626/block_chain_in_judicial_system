import 'package:block_chain_in_judicial_system/Pages/loginpage.dart';
import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child:  MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      theme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home:const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
