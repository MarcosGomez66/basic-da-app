import 'package:basic_da_app/app/app.dart';
import 'package:basic_da_app/models/business_model.dart';
import 'package:basic_da_app/models/product_model.dart';
import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(BusinessModelAdapter());
  Hive.registerAdapter(ProductModelAdapter());

  await Hive.openBox<BusinessModel>('businesses');

  runApp(const MyApp());
}