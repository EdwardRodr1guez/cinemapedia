import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MovieHorizontalListview extends StatefulWidget {
  final List<Movie> movies;
  final String? title;
  final String? subtitle;
  final VoidCallback? loadNextPage;
  const MovieHorizontalListview(
      {super.key,
      required this.movies,
      this.title,
      this.subtitle,
      this.loadNextPage});

  @override
  State<MovieHorizontalListview> createState() =>
      _MovieHorizontalListviewState();
}

class _MovieHorizontalListviewState extends State<MovieHorizontalListview> {
  final scrollController = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController.addListener(() {
      //TODO:
      if (widget.loadNextPage == null) {
        return;
      } else {
        if (scrollController.position.pixels + 150 >=
            scrollController.position.maxScrollExtent) {
          log("load next movies");
          widget.loadNextPage!();
        }
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleLarge;
    final subTitleStyle = Theme.of(context).textTheme.titleSmall;
    final bodyMediumStyle = Theme.of(context).textTheme.bodyMedium;

    return SizedBox(
      height: 350,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                if (widget.title != null)
                  Text(
                    widget.title!,
                    style: titleStyle,
                  ),
                const Spacer(),
                if (widget.subtitle != null)
                  FilledButton.tonal(
                      style: const ButtonStyle(
                          visualDensity: VisualDensity.compact),
                      onPressed: () {},
                      child: Text(widget.subtitle!))
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: ListView.builder(
              controller: scrollController,
              itemCount: widget.movies.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final movie = widget.movies[index];
                return FadeInRight(
                  child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 150,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                fit: BoxFit.cover,
                                movie.posterPath,
                                width: 150,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress != null) {
                                    return const Padding(
                                      padding: EdgeInsets.all(20),
                                      child: Center(
                                          child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      )),
                                    );
                                  }
                                  return FadeIn(child: child);
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          SizedBox(
                              width: 150,
                              child: Text(
                                movie.title,
                                //textAlign: TextAlign.center,
                                maxLines: 2,
                                style: subTitleStyle,
                              )),
                          SizedBox(
                            width: 140,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star_half_outlined,
                                      color: Colors.yellow.shade800,
                                    ),
                                    Text(
                                      '${movie.voteAverage}',
                                      style: bodyMediumStyle?.copyWith(
                                          color: Colors.yellow.shade800),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    NumberFormat.compactCurrency(
                                            decimalDigits: 0,
                                            symbol: '',
                                            locale: 'en')
                                        .format(movie.popularity),
                                    style: bodyMediumStyle,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      )),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
