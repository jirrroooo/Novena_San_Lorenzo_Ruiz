part of 'perpetual_novena_bloc.dart';

@immutable
sealed class PerpetualNovenaState {}

final class PerpetualNovenaInitial extends PerpetualNovenaState {}

final class PerpetualNovenaFetchedSuccess extends PerpetualNovenaState {
  final PerpetualNovenaModel perpetualNovenaModel;

  PerpetualNovenaFetchedSuccess({required this.perpetualNovenaModel});
}

final class PerpetualNovenaFetchedFailure extends PerpetualNovenaState {
  final String error;

  PerpetualNovenaFetchedFailure(this.error);
}

final class PerpetualNovenaFetchedLoading extends PerpetualNovenaState {}
