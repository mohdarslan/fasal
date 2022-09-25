import 'package:app/utils/constants.dart';
import 'package:app/view_models/movies_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class MovieDetail extends StatefulWidget {
  final movieId;
  MovieDetail({Key? key, required this.movieId}) : super(key: key);

  @override
  State<MovieDetail> createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  @override
  void initState() {
    MoviesViewModel.instance.getMovieDetails(movieId: widget.movieId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MovieVM = Provider.of<MoviesViewModel>(context, listen: true);
    return Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: MovieVM.movieDetailLoadingStatus == LoadingStatus.WAITING
              ? Center(child: Text('Please Wait..'))
              : MovieVM.movieDetailLoadingStatus == LoadingStatus.ERROR
                  ? Text('Some error occurred')
                  : Column(
                      children: [
                        if (MovieVM.movie?.posterPath != null)
                          Container(
                            height: 250.h,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        MovieVM.movie!.posterPath!),
                                    fit: BoxFit.fitWidth)),
                          ),
                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            children: [
                              16.verticalSpace,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      MovieVM.movie!.title,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Text(
                                      'Runtime: ${MovieVM.movie!.runtime} mint')
                                ],
                              ),
                              16.verticalSpace,
                              Text(MovieVM.movie!.overview),
                              16.verticalSpace,
                              Text(
                                'Languages Available',
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                              16.verticalSpace,
                              ...MovieVM.movie!.spokenLanguages
                                  .map((e) => Text(' - ' + e.englishName))
                                  .toList(),
                              16.verticalSpace,
                              Text(
                                'Budget',
                                style: _headingTextStyle,
                              ),
                              16.verticalSpace,
                              Text(MovieVM.movie!.budget.toString()),
                              16.verticalSpace,
                              if (MovieVM.movie?.releaseDate != null) ...[
                                Text(
                                  'Release Date',
                                  style: _headingTextStyle,
                                ),
                                16.verticalSpace,
                                Text(
                                    '${MovieVM.movie!.releaseDate!.month}/${MovieVM.movie!.releaseDate!.year}')
                              ]
                            ],
                          ),
                        ),
                      ],
                    ),
        ));
  }
}

TextStyle _headingTextStyle =
    TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600);
