part of 'tv_show_list_bloc.dart';

abstract class TvShowListEvent extends Equatable {
  const TvShowListEvent();

  @override
  List<Object> get props => [];
}

class OnFetchNowPlayingTvShows extends TvShowListEvent {
  const OnFetchNowPlayingTvShows();
}

class OnFetchPopularTvShows extends TvShowListEvent {
  const OnFetchPopularTvShows();
}

class OnFetchTopRatedTvShows extends TvShowListEvent {
  const OnFetchTopRatedTvShows();
}

class OnLoadingTvShowList extends TvShowListEvent {
  const OnLoadingTvShowList();
}
