part of 'prayer_bloc.dart';

@immutable
sealed class PrayerState {}

final class PrayerInitial extends PrayerState {}

final class PrayerFetchedLoading extends PrayerState {}

final class PrayerFetchedFailure extends PrayerState {
  final String error;

  PrayerFetchedFailure(this.error);
}

final class PrayerFetchedSuccess extends PrayerState {
  final List<PrayerModel> prayers;

  PrayerFetchedSuccess({required this.prayers});
}
