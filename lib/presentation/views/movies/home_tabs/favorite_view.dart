import 'dart:developer';

import 'package:cinemapedia/presentation/providers/storage/favorite_movies_provider.dart';
import 'package:cinemapedia/presentation/widgets/movie_masonry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesView extends ConsumerStatefulWidget {
  const FavoritesView({super.key});

  @override
  FavoritesViewState createState() => FavoritesViewState();
}

class FavoritesViewState extends ConsumerState<FavoritesView> {
  bool isLastPage = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    //ref.read(favoriteMoviesProvider.notifier).loadNextPage();
    loadNextPage();
  }

  void loadNextPage() async {
    if (isLoading || isLastPage) {
      return;
    }
    isLoading = true;
    final movies =
        await ref.read(favoriteMoviesProvider.notifier).loadNextPage();
    isLoading = false;
    if (movies.isEmpty) {
      isLastPage = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    log("estoy en favoritos");
    final favoritesMovies = ref.watch(favoriteMoviesProvider).values.toList();
    return Center(
      child: SizedBox(
        //height: 500 * 0,
        child: Column(
          children: [
            Flexible(
                child: MovieMasonry(
                    loadNextPage: loadNextPage, movies: favoritesMovies)),
          ],
        ),
      ),
    );
    /*Column(
      children: [
        SizedBox(
            height: 300,
            child: MovieMasonry(
                loadNextPage: loadNextPage, movies: favoritesMovies))
      ],
    );*/

    /*Scaffold(
        body:
            MovieMasonry(loadNextPage: loadNextPage, movies: favoritesMovies));*/
  }
}
