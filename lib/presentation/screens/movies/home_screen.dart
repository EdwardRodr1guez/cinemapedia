import 'package:cinemapedia/presentation/views/movies/home_tabs/favorite_view.dart';
import 'package:cinemapedia/presentation/views/movies/home_tabs/home_view.dart';
import 'package:cinemapedia/presentation/widgets/custom_bottomnavigationbar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final int pageIndex;
  const HomeScreen({super.key, required this.pageIndex});
  static String name = "homeScreen";

  final viewRoutes = const <Widget>[HomeView(), SizedBox(), FavoritesView()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IndexedStack(
          index: pageIndex,
          children: viewRoutes,
        ),
        bottomNavigationBar:
            CustomBottomNavigationBar(currentIndex: pageIndex));
  }
}
