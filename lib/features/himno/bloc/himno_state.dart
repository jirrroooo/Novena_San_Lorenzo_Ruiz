part of 'himno_bloc.dart';

@immutable
sealed class HimnoState {}

final class HimnoInitial extends HimnoState {}

final class HimnoFetchedLoading extends HimnoState {}

final class HimnoFetchedSuccess extends HimnoState {
  final HimnoModel himnoModel;

  HimnoFetchedSuccess({required this.himnoModel});
}

final class HimnoFetchedFailure extends HimnoState {
  final String error;

  HimnoFetchedFailure(this.error);
}
