part of 'biography_bloc.dart';

@immutable
sealed class BiographyState {}

final class BiographyInitial extends BiographyState {}

final class BiographyFetchedLoading extends BiographyState {}

final class BiographyFetchedFailure extends BiographyState {
  final String error;

  BiographyFetchedFailure(this.error);
}

final class BiographyFetchedSuccess extends BiographyState {
  final BiographyModel biographyModel;

  BiographyFetchedSuccess({required this.biographyModel});
}
