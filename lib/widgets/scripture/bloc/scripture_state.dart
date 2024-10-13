part of 'scripture_bloc.dart';

@immutable
sealed class ScriptureState {}

final class ScriptureInitial extends ScriptureState {}

final class ScriptureFetchedSuccess extends ScriptureState {
  final ScriptureModel scriptureModel;

  ScriptureFetchedSuccess({required this.scriptureModel});
}

final class ScriptureFetchedFailure extends ScriptureState {
  final String error;

  ScriptureFetchedFailure(this.error);
}

final class ScriptureFetchedLoading extends ScriptureState {}
