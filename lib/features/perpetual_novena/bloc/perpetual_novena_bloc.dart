import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:novena_lorenzo/data/translation.dart';
import 'package:novena_lorenzo/features/perpetual_novena/models/perpetual_novena_model.dart';
import 'package:novena_lorenzo/features/perpetual_novena/repository/perpetual_novena_repository.dart';

part 'perpetual_novena_event.dart';
part 'perpetual_novena_state.dart';

class PerpetualNovenaBloc
    extends Bloc<PerpetualNovenaEvent, PerpetualNovenaState> {
  final PerpetualNovenaRepository perpetualNovenaRepository;

  PerpetualNovenaBloc(this.perpetualNovenaRepository)
      : super(PerpetualNovenaInitial()) {
    on<PerpetualNovenaFetched>(_getPerpetualNovenaPrayer);
  }

  void _getPerpetualNovenaPrayer(
      PerpetualNovenaFetched event, Emitter<PerpetualNovenaState> emit) async {
    emit(PerpetualNovenaFetchedLoading());

    try {
      final perpetualNovenaModel = await perpetualNovenaRepository
          .getPerpetualNovenaPrayer(event.translation);

      emit(PerpetualNovenaFetchedSuccess(
          perpetualNovenaModel: perpetualNovenaModel));
    } catch (e) {
      emit(PerpetualNovenaFetchedFailure(e.toString()));
    }
  }
}
