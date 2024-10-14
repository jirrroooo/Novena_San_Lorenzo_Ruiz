part of 'perpetual_novena_bloc.dart';

@immutable
sealed class PerpetualNovenaEvent {}

final class PerpetualNovenaFetched extends PerpetualNovenaEvent {
  final Translation translation;

  PerpetualNovenaFetched({required this.translation});
}
