import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/actors/actors_by_movie_provider.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_detail_provider.dart';
import 'package:cinemapedia/presentation/providers/storage/local_storage_repository_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieScreen extends ConsumerStatefulWidget {
  static const name = "movieScreen";
  final String movieId;
  const MovieScreen({super.key, required this.movieId});

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorsByMovieProvider.notifier).loadActors(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    final movie = ref.watch(movieInfoProvider)[widget.movieId];

    if (movie == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomsliverAppbar(movie: movie),
          SliverList(
              delegate:
                  SliverChildBuilderDelegate(childCount: 1, (context, index) {
            return _MovieDetails(movie: movie);
          }))
        ],
      ),
    );
  }
}

final isFavoriteProvider = FutureProvider.family.autoDispose((
  ref,
  int movieId,
) async {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);

  return localStorageRepository.isMovieFavorite(movieId);
});

class _CustomsliverAppbar extends ConsumerWidget {
  final Movie movie;
  const _CustomsliverAppbar({required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue isFavoriteFuture = ref.watch(isFavoriteProvider(movie.id));
    return SliverAppBar(
      actions: [
        IconButton(
            onPressed: () async {
              ref.watch(localStorageRepositoryProvider).toggleFavorite(movie);
            },
            icon: isFavoriteFuture.when(
                data: (data) {
                  ref.invalidate(isFavoriteProvider(movie.id));
                  return data
                      ? const Icon(Icons.favorite_rounded, color: Colors.red)
                      : const Icon(Icons.favorite_border);
                },
                error: (error, stackTrace) {
                  throw UnimplementedError();
                },
                loading: () => const CircularProgressIndicator(
                      strokeWidth: 2,
                    )))
        //IconButton(onPressed: (){}, icon: Icon(Icons.favorite_rounded, color: Colors.red))
      ],
      backgroundColor: Colors.black,
      expandedHeight: MediaQuery.of(context).size.height * 0.7,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 10, bottom: 10),
        title: Text(
          movie.title,
          textAlign: TextAlign.start,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) {
                    return const SizedBox();
                  }
                  return FadeIn(child: child);
                },
              ),
            ),
            const SizedBox.expand(
              child: DecoratedBox(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          stops: [0.8, 1],
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black87]))),
            ),
            const SizedBox.expand(
              child: DecoratedBox(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          stops: [0, 0.3],
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black87,
                            Colors.transparent,
                          ]))),
            )
          ],
        ),
      ),
    );
  }
}

class _MovieDetails extends StatelessWidget {
  final Movie movie;
  const _MovieDetails({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyle = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  movie.posterPath,
                  width: size.width * 0.3,
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              SizedBox(
                width: (size.width - 60) * (0.62),
                child: Column(
                  children: [
                    //Text(movie.title, style: textStyle.titleLarge),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(movie.overview, textAlign: TextAlign.justify),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Wrap(
            children: [
              ...movie.genreIds.map((gender) => Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: Chip(
                      label: Text(gender),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ))
            ],
          ),
        ),
        _ActorByMovie(movieId: movie.id),
        const SizedBox(
          height: 80,
        )
      ],
    );
  }
}

class _ActorByMovie extends ConsumerWidget {
  final int movieId;
  const _ActorByMovie({required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actorsByMovie = ref.watch(actorsByMovieProvider);

    if (actorsByMovie[movieId.toString()] == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final actors = actorsByMovie[movieId.toString()];

    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors!.length,
        itemBuilder: (context, index) {
          final actor = actors[index];
          return Container(
            padding: const EdgeInsets.all(8),
            width: 135,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInRight(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      actor.profilePath,
                      height: 180,
                      width: 135,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  actor.name,
                  maxLines: 2,
                ),
                Text(
                  actor.character ?? "",
                  maxLines: 2,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
