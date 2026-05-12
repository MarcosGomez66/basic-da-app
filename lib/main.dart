import 'package:basic_da_app/app/app.dart';
import 'package:basic_da_app/models/business_model.dart';
import 'package:basic_da_app/models/product_model.dart';
import 'package:basic_da_app/models/workday_model.dart';
import 'package:basic_da_app/providers/business_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(BusinessModelAdapter());
  Hive.registerAdapter(WorkdayModelAdapter());
  Hive.registerAdapter(ProductModelAdapter());

  await Hive.openBox<BusinessModel>('businesses');
  await Hive.openBox<WorkdayModel>('workdays');

  runApp(
    ChangeNotifierProvider(
      create: (_) => BusinessProvider(),
      child: const MyApp(),
    )
  );
}