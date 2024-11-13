import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:novena_lorenzo/features/biography/models/biography_model.dart';
import 'package:novena_lorenzo/features/biography/repository/biography_repository.dart';

part 'biography_event.dart';
part 'biography_state.dart';

class BiographyBloc extends Bloc<BiographyEvent, BiographyState> {
  BiographyRepository biographyRepository = BiographyRepository();

  BiographyBloc(this.biographyRepository) : super(BiographyInitial()) {
    on<BiographyFetched>((event, emit) async {
      emit(BiographyFetchedLoading());

      try {
        final BiographyModel biographyModel =
            await biographyRepository.getBiograpy();

        emit(BiographyFetchedSuccess(biographyModel: biographyModel));
      } catch (e) {
        emit(BiographyFetchedFailure(e.toString()));
      }
    });
  }
}
