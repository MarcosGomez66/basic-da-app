import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> business = [
      'Despensa',
      'Venta de bebidas en general',
      'Venta de ropas',
    ];

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //texto de bienvenida
            const Text(
              'Bienvenido!, selecciona un negocio o crea uno nuevo',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            //lista de negocios
            Expanded(
              child: ListView.builder(
                itemCount: business.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.store),
                    title: Text(business[index]),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/home',
                        arguments: business[index],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}