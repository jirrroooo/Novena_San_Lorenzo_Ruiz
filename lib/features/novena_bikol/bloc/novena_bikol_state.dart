part of 'novena_bikol_bloc.dart';

@immutable
sealed class NovenaBikolState {}

final class NovenaBikolInitial extends NovenaBikolState {}

final class NovenaBikolTitleFetchedLoading extends NovenaBikolState {}

final class NovenaBikolTitleFetchedFailure extends NovenaBikolState {
  final String error;

  NovenaBikolTitleFetchedFailure(this.error);
}

final class NovenaBikolTitleFetchedSuccess extends NovenaBikolState {
  final List<NovenaBikolHomeModel> titleList;

  NovenaBikolTitleFetchedSuccess({required this.titleList});
}

final class NovenaBikolPageFetcedLoading extends NovenaBikolState {}

final class NovenaBikolPageFetchedFailure extends NovenaBikolState {
  final String error;

  NovenaBikolPageFetchedFailure(this.error);
}

final class NovenaBikolPageFetchedSuccess extends NovenaBikolState {
  final NovenaBikolPageModel novenaDetail;

  NovenaBikolPageFetchedSuccess({required this.novenaDetail});
}
