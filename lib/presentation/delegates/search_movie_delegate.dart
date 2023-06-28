import 'dart:async';
import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  //se crea una clase search delegate
  //se overidean los metodos no implementados
  //hay algunos métodos, getters y setters propios de searchdelegate como searchFieldLabel, query y close(context, result)

  Timer? _debounceTimer;
  StreamController<List<Movie>> debounceMovies = StreamController.broadcast();
  StreamController<bool> isLoading = StreamController.broadcast();

  final SearchMoviesCallback searchMovies;
  List<Movie>
      initialMovies; //ya no es final para que pueda ser cambiada desde acá adentro

  SearchMovieDelegate(
      {required this.searchMovies, this.initialMovies = const []});

  void _onQueryChanged(String query) {
    isLoading.add(true);
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      final movies = await searchMovies(query);
      initialMovies = movies;
      debounceMovies.add(movies);
      isLoading.add(false);
    });
  }

  void clearStream() {
    debounceMovies.close();
  }

  Widget buildResultsAndSuggestions() {
    return StreamBuilder(
      initialData: initialMovies,
      stream: debounceMovies.stream, //searchMovies(query),
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return _MovieItem(
              movie: movie,
              close: (context, movie) {
                clearStream();
                close(context, movie);
              },
            );
          },
        );
      },
    );
  }

  @override
  String get searchFieldLabel => 'Buscar película';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      StreamBuilder(
        stream: isLoading.stream,
        initialData: false,
        builder: (BuildContext context, snapshot) {
          if (snapshot.data == false) {
            return FadeIn(
              animate: query.isNotEmpty,
              child: IconButton(
                  onPressed: () {
                    query = "";
                  },
                  icon: const Icon(Icons.clear)),
            );
          } else {
            return SpinPerfect(
              duration: const Duration(seconds: 5),
              infinite: true,
              animate: query.isNotEmpty,
              child: IconButton(
                  onPressed: () {
                    query = "";
                  },
                  icon: const Icon(Icons.refresh)),
            );
          }
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          clearStream();
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back_ios_new_rounded));
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildResultsAndSuggestions();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChanged(query);
    log("realizando petición");
    return buildResultsAndSuggestions();
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;
  final Function close;
  const _MovieItem({required this.movie, required this.close});

  @override
  Widget build(BuildContext context) {
    final textstyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        close(context, movie);
      },
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: [
              SizedBox(
                  width: size.width * 0.2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      movie.posterPath,
                      loadingBuilder: (context, child, loadingProgress) {
                        return FadeIn(child: child);
                      },
                    ),
                  )),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: size.width * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: textstyles.titleMedium,
                    ),
                    movie.overview.length > 100
                        ? Text(movie.overview.substring(0, 100))
                        : Text(movie.overview),
                    Row(
                      children: [
                        Icon(
                          Icons.star_half_rounded,
                          color: Colors.yellow.shade800,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          NumberFormat.compactCurrency(
                                  decimalDigits: 1, symbol: '', locale: 'en')
                              .format(movie.voteAverage),
                          style: textstyles.bodySmall!
                              .copyWith(color: Colors.yellow.shade800),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}
