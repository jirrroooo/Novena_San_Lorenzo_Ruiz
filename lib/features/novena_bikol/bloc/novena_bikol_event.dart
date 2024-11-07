part of 'novena_bikol_bloc.dart';

@immutable
sealed class NovenaBikolEvent {}

final class NovenaBikolTitleFetched extends NovenaBikolEvent {}

final class NovenaBikolPageFetced extends NovenaBikolEvent {
  final int index;

  NovenaBikolPageFetced({required this.index});
}
