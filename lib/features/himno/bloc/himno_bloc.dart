import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:novena_lorenzo/features/himno/models/himno_model.dart';
import 'package:novena_lorenzo/features/himno/repository/himno_repository.dart';

part 'himno_event.dart';
part 'himno_state.dart';

class HimnoBloc extends Bloc<HimnoEvent, HimnoState> {
  HimnoRepository himnoRepository = HimnoRepository();

  HimnoBloc(this.himnoRepository) : super(HimnoInitial()) {
    on<HimnoFetched>((event, emit) async {
      emit(HimnoFetchedLoading());

      try {
        final HimnoModel himnoModel = await himnoRepository.getHimno();

        emit(HimnoFetchedSuccess(himnoModel: himnoModel));
      } catch (e) {
        emit(HimnoFetchedFailure(e.toString()));
      }
    });
  }
}
