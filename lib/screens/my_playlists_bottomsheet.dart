import 'package:app/models/movie.dart';
import 'package:app/models/movies.dart';
import 'package:app/models/playlist.dart';
import 'package:app/screens/add_new_playlist.dart';
import 'package:app/utils/constants.dart';
import 'package:app/view_models/movies_viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class MyPlaylists extends StatefulWidget {
  final Result movie;
  const MyPlaylists({Key? key, required this.movie}) : super(key: key);

  @override
  State<MyPlaylists> createState() => _MyPlaylistsState();
}

class _MyPlaylistsState extends State<MyPlaylists> {
  List<bool>? isAdding;
  @override
  Widget build(BuildContext context) {
    final MoviesVM = Provider.of<MoviesViewModel>(context, listen: true);
    List<Playlist>? myPlaylists = MoviesVM.playlists
        ?.where((e) => e.createdBy == FirebaseAuth.instance.currentUser?.uid)
        .toList();
    if (myPlaylists != null) {
      if (isAdding == null || isAdding!.length < myPlaylists.length)
        isAdding = List.generate(myPlaylists.length, (x) => false);
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              8.verticalSpace,
              if (myPlaylists == null && myPlaylists?.isEmpty == true) ...[
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddNewPlaylist()));
                  },
                  child: Text(
                    'Create a new Playlist',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ] else ...[
                Text(
                  'Your Playlist',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600),
                ),
                16.verticalSpace,
                for (int i = 0; i < myPlaylists!.length; i++)
                  Expanded(
                      child: ListView(
                    children: [
                      if (myPlaylists[i].movieIds.contains(widget.movie.id))
                        Text('${myPlaylists[i].name} contains this movie')
                      else
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                              onTap: () async {
                                myPlaylists[i].movieIds.add(widget.movie.id);
                                isAdding![i] = true;
                                setState(() {});
                                await FirebaseFirestore.instance
                                    .collection('playlists')
                                    .doc(myPlaylists[i].id)
                                    .update(
                                        {'movieIds': myPlaylists[i].movieIds});
                                isAdding![i] = false;
                                setState(() {});
                              },
                              child: Row(
                                children: [
                                  Text(
                                    myPlaylists[i].name,
                                    style: TextStyle(
                                        fontSize: 16.sp, color: Colors.black),
                                  ),
                                  16.horizontalSpace,
                                  isAdding![i]
                                      ? CircularProgressIndicator()
                                      : Icon(Icons.add)
                                ],
                              )),
                        ),
                    ],
                  )),
                16.verticalSpace,
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddNewPlaylist()));
                  },
                  child: Row(
                    children: [
                      Text(
                        'Add a new Playlist',
                        style: TextStyle(
                          color: brandColor,
                        ),
                      ),
                      Icon(Icons.add, color: brandColor)
                    ],
                  ),
                ),
              ],
              8.verticalSpace
            ]),
      ),
    );
  }
}
