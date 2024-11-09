part of 'novena_english_bloc.dart';

@immutable
sealed class NovenaEnglishEvent {}

final class NovenaEnglishPageFetch extends NovenaEnglishEvent {
  final int index;

  NovenaEnglishPageFetch({required this.index});
}

final class NovenaEnglishHomeFetch extends NovenaEnglishEvent {}
