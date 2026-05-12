import 'package:basic_da_app/providers/business_provider.dart';
import 'package:basic_da_app/screens/summary_screen.dart';
import 'package:basic_da_app/screens/dashboard_screen.dart';
import 'package:basic_da_app/screens/stock_screen.dart';
import 'package:basic_da_app/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int currentIndex = 0;
  final List<Widget> screens = const [
    SummaryScreen(),
    DashboardScreen(),
    StockScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      //boton central para vender
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.point_of_sale, color: Colors.white,),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: const Text('Proximamente: Formulario de venta'),)
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      //botones para navegacion entre pantallas principales
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                Icons.home,
                color: currentIndex == 0 ? Colors.deepPurple : Colors.grey,
              ),
              onPressed: () => setState(() => currentIndex = 0),
            ),
            const SizedBox(width: 10,),
            IconButton(
              icon: Icon(
                Icons.dashboard,
                color: currentIndex == 1 ? Colors.deepPurple : Colors.grey,
              ),
              onPressed: () => setState(() => currentIndex = 1),
            ),
            const SizedBox(width: 20,),
            IconButton(
              icon: Icon(
                Icons.inventory,
                color: currentIndex == 2 ? Colors.deepPurple : Colors.grey,
              ),
              onPressed: () => setState(() => currentIndex = 2),
            ),
            const SizedBox(width: 10,),
            IconButton(
              icon: Icon(
                Icons.settings,
                color: currentIndex == 3 ? Colors.deepPurple : Colors.grey,
              ),
              onPressed: () => setState(() => currentIndex = 3),
            ),
          ],
        ),
      ),
    );
  }
}