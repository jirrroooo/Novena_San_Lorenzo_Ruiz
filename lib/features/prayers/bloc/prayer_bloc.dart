import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:novena_lorenzo/features/prayers/models/prayer_model.dart';
import 'package:novena_lorenzo/features/prayers/repository/prayer_repository.dart';

part 'prayer_event.dart';
part 'prayer_state.dart';

class PrayerBloc extends Bloc<PrayerEvent, PrayerState> {
  PrayerRepository prayerRepository = PrayerRepository();

  PrayerBloc(this.prayerRepository) : super(PrayerInitial()) {
    on<PrayersFetched>((event, emit) async {
      emit(PrayerFetchedLoading());

      try {
        final List<PrayerModel> prayers = await prayerRepository.getPrayers();

        emit(PrayerFetchedSuccess(prayers: prayers));
      } catch (e) {
        PrayerFetchedFailure(e.toString());
      }
    });
  }
}
