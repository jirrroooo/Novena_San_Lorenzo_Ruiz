part of 'novena_english_bloc.dart';

@immutable
sealed class NovenaEnglishState {}

final class NovenaEnglishInitial extends NovenaEnglishState {}

final class NovenaEnglishHomeFetchLoading extends NovenaEnglishState {}

final class NovenaEnglishHomeFetchFailure extends NovenaEnglishState {
  final String error;

  NovenaEnglishHomeFetchFailure(this.error);
}

final class NovenaEnglishHomeFetchSuccess extends NovenaEnglishState {
  final List<NovenaEnglishHomeModel> homeModel;

  NovenaEnglishHomeFetchSuccess({required this.homeModel});
}

final class NovenaEnglishPageFetchLoading extends NovenaEnglishState {}

final class NovenaEnglishPageFetchFailure extends NovenaEnglishState {
  final String error;

  NovenaEnglishPageFetchFailure(this.error);
}

final class NovenaEnglishPageFetchSuccess extends NovenaEnglishState {
  final NovenaEnglishPageModel pageModel;

  NovenaEnglishPageFetchSuccess({required this.pageModel});
}
