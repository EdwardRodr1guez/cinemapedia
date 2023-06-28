import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchQueryprovider = StateProvider<String>((ref) {
  return "";
});

final searchedMoviesProvider =
    StateNotifierProvider<searchedMoviesNotifier, List<Movie>>((ref) {
  final movieRepository = ref.read(movieRepositoryProvider);
  return searchedMoviesNotifier(
      searchMovies: movieRepository.searchMovie, ref: ref);
});

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class searchedMoviesNotifier extends StateNotifier<List<Movie>> {
  SearchMoviesCallback searchMovies;
  final Ref ref;
  searchedMoviesNotifier({required this.searchMovies, required this.ref})
      : super([]);

  Future<List<Movie>> searchMoviesByQuery(String query) async {
    final List<Movie> movies = await searchMovies(query);
    ref.read(searchQueryprovider.notifier).update((state) => query);
    state = movies;
    return movies;
  }
}
