import 'package:app/screens/movies/movie_detail.dart';
import 'package:app/screens/search/search.dart';
import 'package:app/utils/constants.dart';
import 'package:app/view_models/movies_viewmodel.dart';
import 'package:app/widgets/customized_text_button.dart';
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
              onTap: () {},
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
                children: [
                  Spacer(),
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
}
