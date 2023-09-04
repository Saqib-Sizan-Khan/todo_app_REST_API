import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/adapter/product_adapter.dart';
import 'package:todo_app/model/product_model.dart';
import 'package:todo_app/adapter/token_box.dart';
import 'package:todo_app/ui/screens/login_screen.dart';
import 'package:todo_app/ui/screens/product_list.dart';

void main() async {
  //Using this for https link
  if (Platform.isWindows || Platform.isAndroid) {
    HttpOverrides.global = MyHttpOverrides();
  }
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  await Hive.openBox<Product>('productBox');
  Hive.registerAdapter(ProductAdapter());
  runApp(MyApp(initialRoute: await _determineInitialRoute()));
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

Future<String> _determineInitialRoute() async {
  final tokenBox = TokenBox();
  final accessToken = await tokenBox.getToken();

  return accessToken != null ? '/productList' : '/login';
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  MyApp({super.key, required this.initialRoute});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      routes: {
        '/productList' : (context) => ProductListPage(),
        '/login' : (context) => LoginUI()
      },
    );
  }
}
