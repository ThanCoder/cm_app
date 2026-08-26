/*
api/search?keyword=viciou&page=1
api/tv-show-genres
api/tv-show-tags
api/movie-genres
api/movies-by-year
api/movie-tags
api/trending/movies
api/trending/tv-shows
 */
// main host
const String hostUrl = 'https://www.homietv.com';
//host
const String api1HostName = 'homietv';
const String api2HostName = 'ysflix';

// movie
const String apiMovieUrl = '$hostUrl/api/movies';
const String apiMovieTagsUrl = '$hostUrl/api/movie-tags';
const String apiMovieGenresUrl = '$hostUrl/api/movie-genres';
// tv
const String apiTvShowUrl = '$hostUrl/api/tv-shows';
const String apiTvShowGenresUrl = '$hostUrl/api/tv-show-genres';
const String apiTvShowTagsUrl = '$hostUrl/api/tv-show-tags';
// search
const String apiSearchUrl = '$hostUrl/api/search?keyword';

// trending
const String apiMovieTrendingUrl = '$hostUrl/api/trending/movies';
const String apiTvShowTrendingUrl = '$hostUrl/api/trending/tv-shows';

//years
const String apiMovieYearsUrl = '$hostUrl/api/movie-years';
const String apiMovieByYearUrl = '$hostUrl/api/movies-by-year';
