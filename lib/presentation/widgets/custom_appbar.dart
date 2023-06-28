import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/delegates/search_movie_delegate.dart';
import 'package:cinemapedia/presentation/providers/search/search_movies_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleMedium;
    return SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Icon(
                  Icons.movie_outlined,
                  color: colors.primary,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  "Cinemapedia",
                  style: titleStyle,
                ),
                const Spacer(),
                IconButton(
                    onPressed: () async {
                      final searchQuery = ref.read(searchQueryprovider);
                      final searchedMovies = ref.read(searchedMoviesProvider);
                      showSearch<Movie?>(
                              query: searchQuery,
                              context: context,
                              delegate: SearchMovieDelegate(
                                  initialMovies: searchedMovies,
                                  searchMovies: ref
                                      .read(searchedMoviesProvider.notifier)
                                      .searchMoviesByQuery))
                          .then((value) {
                        if (value != null) {
                          context.push('/movie/${value.id}');
                        }
                      }); //se manda la referencia
                    },
                    icon: const Icon(Icons.search))
              ],
            ),
          ),
        ));
  }
}
