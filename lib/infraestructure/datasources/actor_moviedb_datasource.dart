import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/actor_datasource.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infraestructure/mappers/actor_mapper.dart';
import 'package:cinemapedia/infraestructure/models/moviedb/credits_response.dart';
import 'package:dio/dio.dart';

class ActorMovieDBDatasource extends ActorDatasource {
  final dio = Dio(BaseOptions(
      baseUrl: "http://api.themoviedb.org/3",
      queryParameters: {
        "api_key": Environment.movieDBKey,
        "language": "es-MX"
      }));
  @override
  Future<List<Actor>> getActorsByMovie(String movieId) async {
    final response = await dio.get("/movie/$movieId/credits");
    if (response.statusCode != 200) {
      throw Exception("actors with id: $movieId not found");
    }

    final actors = CreditsResponse.fromMap(response.data);
    final List<Actor> movie =
        actors.cast!.map((cast) => ActorMapper.castToEntity(cast)).toList();

    return movie;
  }
}
