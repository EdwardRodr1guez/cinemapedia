import 'package:cinemapedia/infraestructure/datasources/isar_local_storage_datasource.dart';
import 'package:cinemapedia/infraestructure/repositories/local_storage_repository_implementation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localStorageRepositoryProvider = Provider((ref) {
  return LocalStorageRepositoryImplementation(IsarDatasource());
});
