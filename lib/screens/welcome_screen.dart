import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
//models
import 'package:basic_da_app/models/business_model.dart';
//providers
import 'package:basic_da_app/providers/business_provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late Box<BusinessModel> businessBox;

  @override
  void initState() {
    super.initState();
    businessBox = Hive.box<BusinessModel>('businesses');
  }

  void createBusiness(String name) {
    final business = BusinessModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name,
      startTime: DateTime.now(),
    );
    businessBox.put(business.id, business);
    setState(() {});
  }

  void showCreateDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nuevo negocio'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Ingrese el nombre del negocio',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                createBusiness(controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Crear'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final businesses = businessBox.values.toList();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              // Texto de bienvenida
              const Text(
                'Bienvenido/a',
                style: TextStyle(fontSize: 36, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const Text(
                'Selecciona un negocio o crea uno nuevo',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              //lista de negocios
              Expanded(
                child: businesses.isEmpty
                    ? const Center(
                        child: Text(
                          'No hay negocios',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: businesses.length,
                        itemBuilder: (context, index) {
                          final business = businesses[index];

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: ListTile(
                                title: Text(
                                  business.name,
                                  textAlign: TextAlign.center,
                                ),
                                onTap: () {
                                  context
                                      .read<BusinessProvider>()
                                      .selectBusiness(business);

                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/home',
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 20),
              //Boton
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: showCreateDialog,
                  child: const Text('Crear nuevo negocio'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
