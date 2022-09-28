// To parse this JSON data, do
//
//     final playlist = playlistFromJson(jsonString);

import 'package:app/models/movie.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

// Playlist playlistFromJson(String str) => Playlist.fromJson(json.decode(str));

String playlistToJson(Playlist data) => json.encode(data.toJson());

class Playlist {
  Playlist(
      {required this.name,
      required this.createdBy,
      required this.isPublic,
      required this.movieIds,
      this.movies,
      this.id});

  String name;
  String createdBy;
  bool isPublic;
  List<int> movieIds;
  String? id;
  List<Movie>? movies;

  factory Playlist.fromJson(Object? object, String id) {
    Map<String, dynamic> json = object as Map<String, dynamic>;
    return Playlist(
        id: id,
        name: json["name"],
        createdBy: json["createdBy"],
        isPublic: json["isPublic"],
        movieIds: List<int>.from(json["movieIds"].map((x) => x)));
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "createdBy": createdBy,
        "isPublic": isPublic,
        "movieIds": List<dynamic>.from(movieIds.map((x) => x)),
      };
}
