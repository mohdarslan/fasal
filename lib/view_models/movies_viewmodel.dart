import 'package:app/models/movie.dart';
import 'package:app/models/movies.dart';
import 'package:app/models/playlist.dart';
import 'package:app/services/api/api.dart';
import 'package:app/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class MoviesViewModel extends ChangeNotifier {
  static MoviesViewModel? _instance;

  static MoviesViewModel get instance {
    _instance ??= MoviesViewModel();
    return _instance!;
  }

  Movies? foundMovies;
  LoadingStatus foundMoviesLoadingStatus = LoadingStatus.WAITING;

  findMovies({required String query}) async {
    foundMoviesLoadingStatus = LoadingStatus.WAITING;
    try {
      foundMovies = await API.findMovies(query: query);
      foundMoviesLoadingStatus = LoadingStatus.COMPLETED;
    } catch (e) {
      foundMoviesLoadingStatus = LoadingStatus.ERROR;
    }
    notifyListeners();
  }

  Movie? movie;
  LoadingStatus movieDetailLoadingStatus = LoadingStatus.WAITING;

  getMovieDetails({required int movieId}) async {
    movieDetailLoadingStatus = LoadingStatus.WAITING;
    try {
      movie = await API.getMovieDetails(movieId: movieId);
      movieDetailLoadingStatus = LoadingStatus.COMPLETED;
    } catch (e) {
      movieDetailLoadingStatus = LoadingStatus.ERROR;
    }
    notifyListeners();
  }

  List<Playlist>? playlists;
  LoadingStatus playlistsLoadingStatus = LoadingStatus.WAITING;

  getPlaylists() async {
    playlistsLoadingStatus = LoadingStatus.WAITING;
    CollectionReference playlistsRef =
        FirebaseFirestore.instance.collection('playlists');
    try {
      QuerySnapshot<Object?> querySnapshot = await playlistsRef.get();
      List<Playlist> allPlaylists = querySnapshot.docs
          .map<Playlist>((e) => Playlist.fromJson(e.data(), e.id))
          .toList();
      playlists = [];
      for (Playlist playlist in allPlaylists) {
        if (playlist.isPublic) {
          playlists?.add(playlist);
        } else {
          if (playlist.createdBy == FirebaseAuth.instance.currentUser!.uid) {
            playlists?.add(playlist);
          }
        }
      }

      for (Playlist playlist in playlists!) {
        playlist.movies = await Future.wait([
          for (int movieId in playlist.movieIds)
            API.getMovieDetails(movieId: movieId)
        ]);
      }

      playlistsLoadingStatus = LoadingStatus.COMPLETED;
    } catch (e) {
      print(e);
      playlistsLoadingStatus = LoadingStatus.ERROR;
    }
    notifyListeners();
  }
}
