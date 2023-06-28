//Define los métodos que yo voy a usar para manejar la data
//Estos son los orígenes de los datos, y son llamados mediante el repository, es decir, acá no se llama nde forma directa

import 'package:cinemapedia/domain/entities/movie.dart';

abstract class MovieDatasource {
  Future<List<Movie>> getNowPlaying({int page = 1});
  Future<List<Movie>> getPopular({int page = 1});
  Future<List<Movie>> getUpcoming({int page = 1});
  Future<List<Movie>> getTopRated({int page = 1});
  Future<Movie> getMovieById(String id);
}
