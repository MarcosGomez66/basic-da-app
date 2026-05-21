import 'package:flutter/material.dart';
//screens
import 'package:basic_da_app/app/main_layout.dart';
import 'package:basic_da_app/screens/welcome_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const WelcomeScreen(),
  '/home' : (context) => const MainLayout(),
};