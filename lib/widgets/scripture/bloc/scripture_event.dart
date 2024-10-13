part of 'scripture_bloc.dart';

@immutable
sealed class ScriptureEvent {}

final class ScriptureFetched extends ScriptureEvent {
  final Translation translation;

  ScriptureFetched({required this.translation});
}
