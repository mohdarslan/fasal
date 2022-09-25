import 'package:app/screens/movies/movie_detail.dart';
import 'package:app/utils/constants.dart';
import 'package:app/view_models/movies_viewmodel.dart';
import 'package:app/widgets/customized_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _controller = TextEditingController();
  ValueNotifier<bool> _isFinding = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final MoviesVM = Provider.of<MoviesViewModel>(context, listen: true);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar:
          AppBar(title: Text('Search'), backgroundColor: Colors.transparent),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  16.verticalSpace,
                  moviesFound(),
                ],
              ),
            ),
            16.verticalSpace,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  border: Border.all(color: brandColor)),
              child: TextFormField(
                style: TextStyle(color: offWhiteColor),
                controller: _controller,
                decoration: InputDecoration(border: InputBorder.none),
              ),
            ),
            16.verticalSpace,
            ValueListenableBuilder<bool>(
                valueListenable: _isFinding,
                builder: (context, isFinding, child) {
                  return CustomizedButton(
                      height: 42,
                      color: brandColor,
                      onTap: () async {
                        _isFinding.value = true;
                        await MoviesVM.findMovies(query: _controller.text);
                        _isFinding.value = false;
                      },
                      widget: isFinding
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 24.h,
                                width: 24.h,
                                child: CircularProgressIndicator(
                                    color: offWhiteColor),
                              ),
                            )
                          : null,
                      borderColor: brandColor,
                      borderRadius: borderRadius,
                      textStyle: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                      text: 'Find');
                }),
            16.verticalSpace
          ],
        ),
      ),
    );
  }

  Widget moviesFound() {
    switch (MoviesViewModel.instance.foundMoviesLoadingStatus) {
      case LoadingStatus.COMPLETED:
        return Column(
            children: MoviesViewModel.instance.foundMovies!.results
                .map((e) => InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MovieDetail(movieId: e.id)));
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 8.h),
                        decoration: BoxDecoration(
                            borderRadius: borderRadius,
                            color: offWhiteColor.withOpacity(0.2)),
                        height: 200,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if (e.posterPath != null)
                              Expanded(
                                flex: 2,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: borderRadius,
                                      color: offWhiteColor,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                            e.posterPath!,
                                          ),
                                          fit: BoxFit.fitWidth)),
                                ),
                              ),
                            Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        e.title,
                                        style: TextStyle(
                                            color: offWhiteColor,
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      8.verticalSpace,
                                      Text(
                                        e.overview,
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      8.verticalSpace,
                                      Text('Average Vote: ${e.voteAverage}')
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ))
                .toList());

      case LoadingStatus.ERROR:
        return SizedBox();

      case LoadingStatus.EMPTY:
        return SizedBox();

      case LoadingStatus.WAITING:
        return SizedBox();
    }
  }
}
