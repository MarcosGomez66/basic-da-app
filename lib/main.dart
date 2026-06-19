import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

//models and app
import 'package:basic_da_app/app/app.dart';
import 'package:basic_da_app/models/business_model.dart';
import 'package:basic_da_app/models/product_model.dart';
import 'package:basic_da_app/models/product_draft_model.dart';
import 'package:basic_da_app/models/lot_model.dart';
import 'package:basic_da_app/models/workday_model.dart';
//providers
import 'package:basic_da_app/providers/business_provider.dart';
import 'package:basic_da_app/providers/workday_provider.dart';
import 'package:basic_da_app/providers/product_draft_provider.dart';
import 'package:basic_da_app/providers/product_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await initializeDateFormatting('es');

  Hive.registerAdapter(BusinessModelAdapter());
  Hive.registerAdapter(WorkdayModelAdapter());
  Hive.registerAdapter(LotModelAdapter());
  Hive.registerAdapter(CostTypeAdapter());
  Hive.registerAdapter(ProductModelAdapter());

  await Hive.openBox<BusinessModel>('businesses');
  await Hive.openBox<WorkdayModel>('workdays');
  await Hive.openBox<LotModel>('lots');
  await Hive.openBox<ProductModel>('products');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => BusinessProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => WorkdayProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductDraftProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductProvider(),
        )
      ],
      child: const MyApp(),
    )
  );
}
