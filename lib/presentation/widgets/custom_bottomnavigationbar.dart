import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  int getCurrentIndex(BuildContext context) {
    final String location = GoRouterState.of(context).location;
    switch (location) {
      case "/":
        return 0;
      case "/categories":
        return 1;
      case "/favorites":
        return 2;
      default:
        return 0;
    }
  }

  void onItemTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go("/");
        break;
      case 1:
        context.go("/");
        break;
      case 2:
        context.go("/favorites");
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex: getCurrentIndex(context), //llamar index basado en context
        onTap: (value) {
          onItemTap(context, value);
        },
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            label: "Inicio",
            icon: Icon(Icons.home_rounded),
          ),
          BottomNavigationBarItem(
            label: "Categorias",
            icon: Icon(Icons.label_outline),
          ),
          BottomNavigationBarItem(
            label: "Favoritos",
            icon: Icon(Icons.favorite_outline),
          ),
        ]);
  }
}
