import 'package:flutter/material.dart';
import 'package:basic_da_app/app/theme.dart';
import 'package:basic_da_app/app/routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BasicDA app',
      theme: appTheme(),
      initialRoute: '/',
      routes: appRoutes,
    );
  }
}
