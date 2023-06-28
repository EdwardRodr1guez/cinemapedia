//lee diferentes modelos y crea la entidad

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infraestructure/models/moviedb/movie_details.dart';
import 'package:cinemapedia/infraestructure/models/moviedb/movie_moviedb.dart';

class MovieMapper {
  static Movie movieDBToentity(MovieMovieDB movieDB) => Movie(
      adult: movieDB.adult!,
      backdropPath: movieDB.backdropPath != "" && movieDB.backdropPath != null
          ? "https://image.tmdb.org/t/p/w500${movieDB.backdropPath}"
          : "https://www.truckeradvisor.com/media/uploads/profilePics/notFound.jpg",
      genreIds: movieDB.genreIds!.map((e) => e.toString()).toList(),
      id: movieDB.id!,
      originalLanguage: movieDB.originalLanguage!,
      originalTitle: movieDB.originalTitle!,
      overview: movieDB.overview!,
      popularity: movieDB.popularity!,
      posterPath: movieDB.posterPath != "" && movieDB.posterPath != null
          ? "https://image.tmdb.org/t/p/w500${movieDB.posterPath}"
          : "https://www.truckeradvisor.com/media/uploads/profilePics/notFound.jpg",
      releaseDate: movieDB.releaseDate!,
      title: movieDB.title!,
      video: movieDB.video!,
      voteAverage: movieDB.voteAverage!,
      voteCount: movieDB.voteCount!);

  static Movie movieDetailsDBToentity(MovieDetails movieDB) => Movie(
      adult: movieDB.adult!,
      backdropPath: movieDB.backdropPath != "" && movieDB.backdropPath != null
          ? "https://image.tmdb.org/t/p/w500${movieDB.backdropPath}"
          : "https://www.truckeradvisor.com/media/uploads/profilePics/notFound.jpg",
      genreIds: movieDB.genres!.map((e) => e.name.toString()).toList(),
      id: movieDB.id!,
      originalLanguage: movieDB.originalLanguage!,
      originalTitle: movieDB.originalTitle!,
      overview: movieDB.overview!,
      popularity: movieDB.popularity!,
      posterPath: movieDB.posterPath != "" && movieDB.posterPath != null
          ? "https://image.tmdb.org/t/p/w500${movieDB.posterPath}"
          : "https://www.truckeradvisor.com/media/uploads/profilePics/notFound.jpg",
      releaseDate: movieDB.releaseDate!,
      title: movieDB.title!,
      video: movieDB.video!,
      voteAverage: movieDB.voteAverage! + 0.0,
      voteCount: movieDB.voteCount!);
}
