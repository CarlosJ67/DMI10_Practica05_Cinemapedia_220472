import 'package:cinemapedia_220472/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia_220472/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia_220472/infrastructure/models/moviedb/moviedb_response.dart';
import 'package:cinemapedia_220472/config/constants/environment.dart';
import 'package:cinemapedia_220472/domain/entities/movie.dart';
import 'package:dio/dio.dart';

/// Implementación concreta del datasource que obtiene datos de TheMovieDB API.
/// 
/// Esta clase se encarga de realizar peticiones HTTP a la API de TheMovieDB
/// y convertir las respuestas JSON en entidades de dominio utilizables.
/// 

class MoviedbDataSource extends MoviesDatasource{
  /// Cliente HTTP configurado para la API de TheMovieDB
  /// Incluye URL base, API key y configuración de idioma
  final Dio dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
    queryParameters: {
      'api_key': Environment.theMovieDbKey,
      'language': 'es-MX',
    }
  ));


  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    /// Realiza petición GET al endpoint de películas en cartelera
    final response = await dio.get('/movie/now_playing', queryParameters: {
      'page': page
    });
    final movieDBResponse = MovieDbResponse.fromJson(response.data);

    /// Filtra películas sin póster y las convierte a entidades
    final List<Movie> movies = movieDBResponse.results
      .where((moviedb)=> moviedb.posterPath != 'no-poster')
      .map(
        (moviedb) => MovieMapper.movieDBToEntity(moviedb)
      ).toList();

    return movies;
  }
}