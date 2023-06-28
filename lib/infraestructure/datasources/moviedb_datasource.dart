import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infraestructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infraestructure/models/moviedb/movie_details.dart';
import 'package:cinemapedia/infraestructure/models/moviedb/moviedb_response.dart';
import 'package:dio/dio.dart';

class MoviedbDatasource extends MovieDatasource {
  final dio = Dio(BaseOptions(
      baseUrl: "http://api.themoviedb.org/3",
      queryParameters: {
        "api_key": Environment.movieDBKey,
        "language": "es-MX"
      }));
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response =
        await dio.get("/movie/now_playing", queryParameters: {"page": page});
    final movieDBResponse = MovieDbResponse.fromMap(response.data);
    final List<Movie> movies = movieDBResponse.results!
        .where((moviedb) => moviedb.posterPath != "")
        .map((moviedb) => MovieMapper.movieDBToentity(moviedb))
        .toList();

    return movies;
  }

  @override
  Future<List<Movie>> getPopular({int page = 1}) async {
    final response =
        await dio.get("/movie/popular", queryParameters: {"page": page});
    final movieDBResponse = MovieDbResponse.fromMap(response.data);
    final List<Movie> movies = movieDBResponse.results!
        .where((moviedb) => moviedb.posterPath != "")
        .map((moviedb) => MovieMapper.movieDBToentity(moviedb))
        .toList();

    return movies;
  }

  @override
  Future<List<Movie>> getUpcoming({int page = 1}) async {
    final response =
        await dio.get("/movie/upcoming", queryParameters: {"page": page});
    final movieDBResponse = MovieDbResponse.fromMap(response.data);
    final List<Movie> movies = movieDBResponse.results!
        .where((moviedb) => moviedb.posterPath != "")
        .map((moviedb) => MovieMapper.movieDBToentity(moviedb))
        .toList();

    return movies;
  }

  @override
  Future<List<Movie>> getTopRated({int page = 1}) async {
    final response =
        await dio.get("/movie/top_rated", queryParameters: {"page": page});
    final movieDBResponse = MovieDbResponse.fromMap(response.data);
    final List<Movie> movies = movieDBResponse.results!
        .where((moviedb) => moviedb.posterPath != "")
        .map((moviedb) => MovieMapper.movieDBToentity(moviedb))
        .toList();

    return movies;
  }

  @override
  Future<Movie> getMovieById(String id) async {
    final response = await dio.get("/movie/$id");
    if (response.statusCode != 200) {
      throw Exception("Movie with id: $id not found");
    }

    final movieDetails = MovieDetails.fromMap(response.data);
    final Movie movie = MovieMapper.movieDetailsDBToentity(movieDetails);

    return movie;
  }

  @override
  Future<List<Movie>> searchMovie(String query) async {
    if (query.isEmpty) {
      return [];
    }
    final response =
        await dio.get("/search/movie", queryParameters: {"query": query});

    final movieDBResponse = MovieDbResponse.fromMap(response.data);
    final List<Movie> movies = movieDBResponse.results!
        .where((moviedb) => moviedb.posterPath != "")
        .map((moviedb) => MovieMapper.movieDBToentity(moviedb))
        .toList();

    return movies;
  }
}
