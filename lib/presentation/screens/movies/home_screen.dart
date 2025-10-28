
import 'package:cinemapedia_220472/presentation/providers/movies/movie_slideshow_provider.dart' show movieSlideshowProvider;
import 'package:cinemapedia_220472/presentation/providers/movies/movies_providers.dart';
import 'package:cinemapedia_220472/presentation/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';


/// Pantalla principal de la aplicación que muestra las películas en cartelera.
/// 
/// **Funcionalidades:**
/// - Lista de películas actualmente en cines
/// - Carga automática de datos al iniciar
/// - Interfaz simple con título y descripción
class HomeScreen extends StatelessWidget {
  /// Identificador único para navegación con GoRouter
  static const name = 'home-screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _HomeView(),
      bottomNavigationBar: CustomButtonNavigationbar(),
    );
  }
}

/// Vista interna que maneja el estado y la lógica de la pantalla principal.
/// 
/// **Responsabilidades:**
/// - Cargar películas al inicializar la pantalla
/// - Escuchar cambios en el provider de películas
class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  @override
  _HomeViewState createState() => _HomeViewState();
}

/// Estado que gestiona el ciclo de vida y la construcción de la vista.
class _HomeViewState extends ConsumerState<_HomeView> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es_ES', null);
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
  }

    /// ✅ Función para obtener la fecha actual formateada
  String get currentFormattedDate {
    final now = DateTime.now();
    final formatter = DateFormat('EEEE, d \'de\' MMMM', 'es_ES');
    return formatter.format(now);
  }

  @override
  Widget build(BuildContext context){
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final slideShowMovies = ref.watch(movieSlideshowProvider);
    return Column(
      children: [
      CustomAppbar(),
        MovieSlidershow(movies: slideShowMovies),
        MovieHorizontalListview(movies: nowPlayingMovies,
        title: 'En cines',
        subTitle: currentFormattedDate,
        loadNextPage: (){
          print('Evento lanzado por el listener de HorizontalListView');
        } ,
        ),
      ]
  );
  }
}