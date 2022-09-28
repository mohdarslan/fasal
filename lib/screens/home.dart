import 'package:app/models/movie.dart';
import 'package:app/models/playlist.dart';
import 'package:app/screens/login/login.dart';
import 'package:app/screens/movies/movie_detail.dart';
import 'package:app/screens/search/search.dart';
import 'package:app/utils/constants.dart';
import 'package:app/view_models/movies_viewmodel.dart';
import 'package:app/widgets/customized_text_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _controller = TextEditingController();
  ValueNotifier<bool> _isFinding = ValueNotifier(false);

  @override
  void initState() {
    MoviesViewModel.instance.getPlaylists();
    super.initState();
  }

  List<bool>? isOpen;

  @override
  Widget build(BuildContext context) {
    final MoviesVM = Provider.of<MoviesViewModel>(context, listen: true);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.transparent,
        actions: [
          CustomizedButton(
              height: 42,
              color: Colors.transparent,
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              text: 'Logout'),
          16.horizontalSpace
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  16.verticalSpace,
                  Text(
                    'Playlists',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18.sp,
                        color: brandColor),
                  ),
                  16.verticalSpace,
                  Expanded(child: _buildPlaylists()),
                  CustomizedButton(
                    height: 42,
                    color: brandColor,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchScreen()));
                    },
                    textStyle: TextStyle(fontSize: 18.sp, color: Colors.white),
                    text: 'Search Movies',
                  ),
                  16.verticalSpace
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPlaylists() {
    switch (MoviesViewModel.instance.playlistsLoadingStatus) {
      case LoadingStatus.COMPLETED:
        {
          if (isOpen == null ||
              MoviesViewModel.instance.playlists!.length > isOpen!.length)
            isOpen = List.generate(
                MoviesViewModel.instance.playlists!.length, (x) => true);
          return ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0;
                  i < MoviesViewModel.instance.playlists!.length;
                  i++)
                getPlaylistUI(index: i)
            ],
          );
        }
      case LoadingStatus.ERROR:
        return SizedBox();

      case LoadingStatus.EMPTY:
        return SizedBox();

      case LoadingStatus.WAITING:
        return Center(child: CircularProgressIndicator());
    }
  }

  Widget getPlaylistUI({required int index}) {
    Playlist playlist = MoviesViewModel.instance.playlists![index];
    if (MoviesViewModel.instance.playlists?.isEmpty == true) return SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              playlist.name,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800),
            ),
            InkWell(
              onTap: () {
                isOpen![index] = !isOpen![index];
                setState(() {});
              },
              child: Icon(
                  isOpen![index]
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: offWhiteColor),
            )
          ],
        ),
        16.verticalSpace,
        AnimatedCrossFade(
            firstChild: SizedBox(),
            secondChild: Column(
              children: [
                if (playlist.movies != null)
                  for (Movie movie in playlist.movies!)
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MovieDetail(movieId: movie.id)));
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
                            if (movie.posterPath != null)
                              Expanded(
                                flex: 2,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: borderRadius,
                                      color: offWhiteColor,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                            movie.posterPath!,
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
                                        movie.title,
                                        style: TextStyle(
                                            color: offWhiteColor,
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      8.verticalSpace,
                                      Text(
                                        movie.overview,
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      8.verticalSpace,
                                      Text('Average Vote: ${movie.voteAverage}')
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                    )
              ],
            ),
            crossFadeState: isOpen![index]
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300))
      ],
    );
  }
}
