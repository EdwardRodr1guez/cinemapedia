import 'package:cinemapedia/presentation/widgets/custom_bottomnavigationbar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final Widget childView;
  const HomeScreen({super.key, required this.childView});
  static String name = "homeScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: childView,
        bottomNavigationBar: const CustomBottomNavigationBar());
  }
}
