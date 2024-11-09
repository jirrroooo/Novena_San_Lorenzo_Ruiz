import 'package:flutter/material.dart';
import 'package:novena_lorenzo/data/translation.dart';
import 'package:novena_lorenzo/widgets/scripture/bloc/scripture_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Scripture extends StatefulWidget {
  final Translation translation;

  const Scripture({super.key, required this.translation});

  @override
  State<Scripture> createState() => _ScriptureState();
}

class _ScriptureState extends State<Scripture> {
  @override
  void initState() {
    context
        .read<ScriptureBloc>()
        .add(ScriptureFetched(translation: widget.translation));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(30),
        child: BlocBuilder<ScriptureBloc, ScriptureState>(
          builder: (context, state) {
            if (state is ScriptureFetchedFailure) {
              return Center(child: Text(state.error));
            }

            if (state is! ScriptureFetchedSuccess) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            var data = state.scriptureModel;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  data.text,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "- ${data.verse}",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
