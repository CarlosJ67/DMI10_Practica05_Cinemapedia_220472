import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia_220472/config/helpers/human_formats.dart';
import 'package:cinemapedia_220472/domain/entities/movie.dart';
import 'package:flutter/material.dart';


class MovieHorizontalListview extends StatefulWidget {

  final List<Movie> movies;
  final String? title;
  final String? subTitle;
  final VoidCallback? loadNextPage;

  const MovieHorizontalListview({super.key, required this.movies, this.title, this.subTitle, this.loadNextPage});

  @override
  State<MovieHorizontalListview> createState() => _MovieHorizontalListviewState();
}

class _MovieHorizontalListviewState extends State<MovieHorizontalListview> {
  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();

    @override 
    void initState(){
      super.initState();
      scrollController.addListener((){
        if(widget.loadNextPage == null) return;
        if(scrollController.position.pixels +200>= scrollController.position.maxScrollExtent){
          print('Cargado las peliculas recientes');
          widget.loadNextPage!();
        }
      });
    }

    return SizedBox(
      height: 370,
      child: Column(
        children: [

          if(widget.title !=null || widget.subTitle !=null)
          _CurrDate(place: widget.title, formateDate: widget.subTitle,),

          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: widget.movies.length,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index){
                return _Slide(movie: widget.movies[index]);
              }
            )
          )
        ],
      ),
    );
  }
}




class _Slide extends StatelessWidget {
  final Movie movie;
  const _Slide({required this.movie});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            height: 200,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                movie.posterPath,
                width: 150,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress!= null){
                    return const Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator(strokeWidth: 2,));
                  }
                  return FadeIn(child: child);
                } ,
              ),
            ),
          ),

          const SizedBox(height: 5),
          
          // ✅ Título con altura flexible
          Flexible( // ✅ Cambiar SizedBox por Flexible
            child: SizedBox(
              width: 150,
              child: Text(
                movie.title,  
                style: const TextStyle(fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          const SizedBox(height: 3,),

         SizedBox(
            width: 150,
            height: 20, 
            child: Row(
              children: [
                Icon(Icons.star_half_outlined, color: Colors.yellow.shade800, size: 16), 
                const SizedBox(width: 3),
                Text( 
                  '${movie.voteAverage.toStringAsFixed(1)}', 
                  style: textStyles.bodyMedium?.copyWith(color: Colors.yellow.shade800),
                ),
                const Spacer(),
                Flexible( 
                  child: Text(
                    HumanFormats.humanReadbleNumber(movie.popularity), 
                    style: textStyles.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class _CurrDate extends StatelessWidget {
  final String? place;
  final String? formateDate;

  const _CurrDate({
    this.place,
    this.formateDate
  });

  @override
  Widget build(BuildContext context) {
    final placeStyle = Theme.of(context).textTheme.titleMedium;

    return Container(
      padding: const EdgeInsets.only(top: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          if(place !=null)
            Text(place!, style: placeStyle,),
          Spacer(),
          if(formateDate!=null)
          FilledButton.tonal(onPressed: (){}, child: Text(formateDate!))
        ],
      ),
    );
  }
}