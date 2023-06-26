import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final moviesSlideshowProvider = Provider<List<Movie>>((ref) {
  final nowplaying = ref.watch(nowPlayingMoviesProvider);
  if (nowplaying.isEmpty) {
    return [];
  }
  return nowplaying.sublist(0, 6).toList();
});
