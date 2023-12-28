import 'package:flutter/material.dart';
import 'package:mb_demo/app/components/Home/home.dart';
import 'package:mb_demo/app/components/Login/login.dart';
import 'package:mb_demo/app/components/about/about.dart';

Map<String, Widget Function(BuildContext)> getRoutes() {
  return {
    '/': (context) => const HomePage(),
    '/login': (context) => const LoginPage(),
    '/about': (context) => const About()
  };
}
