import 'package:cinemapedia/presentation/screens/movies/home_screen.dart';
import 'package:cinemapedia/presentation/screens/movies/movie_screen.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(initialLocation: "/home/0", routes: [
  /*ShellRoute(
      builder: (context, state, child) {
        return const HomeScreen();
      },
      routes: [
        GoRoute(
            path: "/",
            builder: (context, state) {
              return const HomeView();
            },
            routes: [
              GoRoute(
                path: "movie/:id", //el id se manda
                name: MovieScreen.name,
                builder: (context, state) {
                  final movieId = state.pathParameters['id'] ?? "no-id";
                  return MovieScreen(movieId: movieId);
                },
              )
            ]),
        GoRoute(
          path: "/favorites",
          builder: (context, state) {
            return const FavoritesView();
          },
        )
      ])*/

  //Rutas padre/hijo
  GoRoute(
      path: "/home/:page",
      name: HomeScreen.name,
      builder: (context, state) {
        final pageIndex = state.pathParameters["page"] ?? '0';
        return HomeScreen(
          pageIndex: int.parse(pageIndex),
        );
      },
      routes: [
        GoRoute(
          path: "movie/:id", //el id se manda
          name: MovieScreen.name,
          builder: (context, state) {
            final movieId = state.pathParameters['id'] ?? "no-id";
            return MovieScreen(movieId: movieId);
          },
        )
      ]),

  GoRoute(path: "/", redirect: (_, __) => "/home/0")
]);
