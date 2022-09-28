import 'package:app/models/playlist.dart';
import 'package:app/utils/constants.dart';
import 'package:app/view_models/movies_viewmodel.dart';
import 'package:app/widgets/customized_text_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddNewPlaylist extends StatefulWidget {
  AddNewPlaylist({Key? key}) : super(key: key);

  @override
  State<AddNewPlaylist> createState() => _AddNewPlaylistState();
}

class _AddNewPlaylistState extends State<AddNewPlaylist> {
  ValueNotifier<bool> _isPublic = ValueNotifier(true);
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Add New Playlist',
                    style: TextStyle(
                        color: brandColor,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600)),
                Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: brandColor)),
                        child: TextFormField(
                          controller: _controller,
                          style:
                              TextStyle(color: offWhiteColor, fontSize: 16.sp),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Playlist Name',
                            hintStyle: TextStyle(
                                color: offWhiteColor.withOpacity(0.1)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                16.verticalSpace,
                ValueListenableBuilder<bool>(
                    valueListenable: _isPublic,
                    builder: (context, isPublic, child) {
                      return Row(
                        children: [
                          Checkbox(
                              value: isPublic,
                              fillColor: MaterialStateProperty.all(
                                  brandColor.withOpacity(0.5)),
                              activeColor: offWhiteColor,
                              onChanged: (_) {
                                _isPublic.value = !_isPublic.value;
                              }),
                          16.horizontalSpace,
                          Text('Make it public')
                        ],
                      );
                    }),
                16.verticalSpace,
                CustomizedButton(
                  height: 42,
                  color: Colors.transparent,
                  onTap: () async {
                    Playlist newPlaylist = Playlist(
                      name: _controller.text,
                      createdBy: FirebaseAuth.instance.currentUser!.uid,
                      isPublic: _isPublic.value,
                      movieIds: [],
                    );
                    DocumentReference<Map<String, dynamic>> snap =
                        await FirebaseFirestore.instance
                            .collection('playlists')
                            .add(newPlaylist.toJson());
                    newPlaylist.id = snap.id;
                    MoviesViewModel.instance.playlists?.add(newPlaylist);
                    Navigator.pop(context);
                  },
                  text: 'Add',
                  borderColor: brandColor,
                ),
                Spacer()
              ],
            ),
          ),
        ));
  }
}
