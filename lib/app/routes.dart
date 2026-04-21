import 'package:basic_da_app/app/main_layout.dart';
import 'package:basic_da_app/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const WelcomeScreen(),
  '/home' : (context) => const MainLayout(),
};