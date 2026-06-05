import 'package:flutter/material.dart';
//screens
import 'package:basic_da_app/app/main_layout.dart';
import 'package:basic_da_app/screens/welcome_screen.dart';
import 'package:basic_da_app/screens/workdays_screen.dart';
import 'package:basic_da_app/screens/lot_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const WelcomeScreen(),
  '/home' : (context) => const MainLayout(),
  '/workdays' : (context) => const WorkdaysScreen(),
  '/lot' : (context) => const LotScreen(),
};