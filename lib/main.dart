import 'package:flutter/material.dart';
import 'package:frest/utils/theme.dart';
import 'package:frest/views/auth/login.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'frest',
      debugShowCheckedModeBanner: false,
      theme: themeData(context),
      home: const Login(),
    );
  }
}
