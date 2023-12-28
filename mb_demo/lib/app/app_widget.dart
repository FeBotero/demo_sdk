import 'package:flutter/material.dart';
import 'package:mb_demo/app/routes.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MB DEMO",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: false),
      initialRoute: "/",
      routes: getRoutes(),
    );
  }
}
