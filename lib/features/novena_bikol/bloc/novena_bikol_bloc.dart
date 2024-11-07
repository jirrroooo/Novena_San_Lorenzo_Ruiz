import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:novena_lorenzo/features/novena_bikol/models/novena_bikol_home_model.dart';
import 'package:novena_lorenzo/features/novena_bikol/models/novena_bikol_page_model.dart';
import 'package:novena_lorenzo/features/novena_bikol/repository/novena_bikol_repository.dart';

part 'novena_bikol_event.dart';
part 'novena_bikol_state.dart';

class NovenaBikolBloc extends Bloc<NovenaBikolEvent, NovenaBikolState> {
  NovenaBikolRepository novenaBikolRepository = NovenaBikolRepository();

  NovenaBikolBloc(this.novenaBikolRepository) : super(NovenaBikolInitial()) {
    on<NovenaBikolTitleFetched>((event, emit) async {
      emit(NovenaBikolTitleFetchedLoading());

      try {
        final titleList = await novenaBikolRepository.getBikolNovenaTitles();

        emit(NovenaBikolTitleFetchedSuccess(titleList: titleList));
      } catch (e) {
        emit(NovenaBikolTitleFetchedFailure(e.toString()));
      }
    });

    on<NovenaBikolPageFetced>((event, emit) async {
      emit(NovenaBikolPageFetcedLoading());

      try {
        final novenaDetail =
            await novenaBikolRepository.getBikolNovenaDetail(event.index);

        emit(NovenaBikolPageFetchedSuccess(novenaDetail: novenaDetail));
      } catch (e) {
        emit(NovenaBikolPageFetchedFailure(e.toString()));
      }
    });
  }
}
