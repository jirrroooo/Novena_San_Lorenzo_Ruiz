import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:novena_lorenzo/data/translation.dart';
import 'package:novena_lorenzo/widgets/scripture/models/scriptureModel.dart';
import 'package:novena_lorenzo/widgets/scripture/repository/scripture_repository.dart';

part 'scripture_event.dart';
part 'scripture_state.dart';

class ScriptureBloc extends Bloc<ScriptureEvent, ScriptureState> {
  final ScriptureRepository scriptureRepository;

  ScriptureBloc(this.scriptureRepository) : super(ScriptureInitial()) {
    on<ScriptureFetched>(_getScriptureInformation);
  }

  void _getScriptureInformation(
      ScriptureFetched event, Emitter<ScriptureState> emit) async {
    emit(ScriptureFetchedLoading());

    print("===> Bloc called");

    try {
      print("===> Test 1 | Translation ${event.translation}");

      final scriptureModel =
          await scriptureRepository.getScripture(event.translation);

      print("===> Scripture Model: $scriptureModel");

      emit(ScriptureFetchedSuccess(scriptureModel: scriptureModel));
    } catch (e) {
      ScriptureFetchedFailure(e.toString());
    }
  }
}
