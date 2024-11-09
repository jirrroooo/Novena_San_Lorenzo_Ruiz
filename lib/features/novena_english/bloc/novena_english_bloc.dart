import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:novena_lorenzo/features/novena_english/models/novena_english_home_model.dart';
import 'package:novena_lorenzo/features/novena_english/models/novena_english_page_model.dart';
import 'package:novena_lorenzo/features/novena_english/repository/novena_english_repository.dart';

part 'novena_english_event.dart';
part 'novena_english_state.dart';

class NovenaEnglishBloc extends Bloc<NovenaEnglishEvent, NovenaEnglishState> {
  NovenaEnglishRepository novenaEnglishRepository = NovenaEnglishRepository();

  NovenaEnglishBloc(this.novenaEnglishRepository)
      : super(NovenaEnglishInitial()) {
    on<NovenaEnglishHomeFetch>((event, emit) async {
      emit(NovenaEnglishHomeFetchLoading());

      try {
        final List<NovenaEnglishHomeModel> homeModel =
            await novenaEnglishRepository.getEnglishNovenaTitles();

        emit(NovenaEnglishHomeFetchSuccess(homeModel: homeModel));
      } catch (e) {
        emit(NovenaEnglishHomeFetchFailure(e.toString()));
      }
    });

    on<NovenaEnglishPageFetch>((event, emit) async {
      emit(NovenaEnglishPageFetchLoading());

      try {
        final NovenaEnglishPageModel pageModel =
            await novenaEnglishRepository.getEnglishNovenaDetail(event.index);

        emit(NovenaEnglishPageFetchSuccess(pageModel: pageModel));
      } catch (e) {
        emit(NovenaEnglishPageFetchFailure(e.toString()));
      }
    });
  }
}
