import 'package:app/models/movie.dart';
import 'package:app/models/movies.dart';
import 'package:app/services/api/api.dart';
import 'package:app/utils/constants.dart';
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
}
