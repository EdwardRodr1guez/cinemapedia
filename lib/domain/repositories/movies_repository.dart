import 'package:cinemapedia/domain/entities/movie.dart';

//Aquí se llaman los orígenes de los datos, es decir primero datasource, despues el repository
abstract class MovieRepositoy {
  Future<List<Movie>> getNowPlaying({int page = 1});
  Future<List<Movie>> getPopular({int page = 1});
  Future<List<Movie>> getUpcoming({int page = 1});
  Future<List<Movie>> getTopRated({int page = 1});
  Future<Movie> getMovieById(String id);
}
