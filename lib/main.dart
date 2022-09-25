// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:app/screens/check_login.dart';
import 'package:app/screens/login/login.dart';
import 'package:app/utils/constants.dart';
import 'package:app/view_models/movies_viewmodel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MoviesViewModel>.value(
            value: MoviesViewModel.instance)
      ],
      child: ScreenUtilInit(
        designSize: Size(390, 806),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (BuildContext context, Widget? child) {
          return MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(
                  primarySwatch: Colors.blue,
                  primaryColor: offWhiteColor,
                  textTheme: TextTheme(
                      bodyText1: TextStyle(color: offWhiteColor),
                      bodyText2: TextStyle(color: offWhiteColor))),
              home: const CheckLogin());
        },
      ),
    );
  }
}
