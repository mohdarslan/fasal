const String apiKey = '276e2a19619a6253a0597316fd665e35';

const String searchAPI =
    'https://api.themoviedb.org/3/search/movie?api_key=$apiKey&page=1&include_adult=false';

String getMovieDetailsAPI(int movieId) =>
    'https://api.themoviedb.org/3/movie/$movieId?api_key=$apiKey';
