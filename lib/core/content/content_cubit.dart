import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novena_lorenzo/core/content/content_loader.dart';
import 'package:novena_lorenzo/core/services/log_service.dart';
import 'package:novena_lorenzo/core/widgets/state_views.dart';

sealed class ContentState<T> {
  const ContentState();
}

final class ContentLoading<T> extends ContentState<T> {
  const ContentLoading();
}

final class ContentLoaded<T> extends ContentState<T> {
  const ContentLoaded(this.data);

  final T data;
}

final class ContentFailed<T> extends ContentState<T> {
  const ContentFailed(this.message);

  final String message;
}

/// Loads one piece of bundled content for a single screen.
///
/// Each screen owns its cubit, so screens never overwrite each other's state
/// (previously the novena list and day pages shared one global bloc).
class ContentCubit<T> extends Cubit<ContentState<T>> {
  ContentCubit(this._load) : super(ContentLoading<T>()) {
    load();
  }

  final Future<T> Function() _load;

  Future<void> load() async {
    emit(ContentLoading<T>());
    try {
      final data = await _load();
      if (!isClosed) emit(ContentLoaded<T>(data));
    } catch (e, s) {
      await LogService.instance.error(e, s);
      if (!isClosed) {
        emit(
          ContentFailed<T>(
            e is ContentLoadException
                ? e.message
                : 'The content could not be loaded.',
          ),
        );
      }
    }
  }
}

/// Loads content with a [ContentCubit] and builds a sliver from it, showing
/// loading and error states in between.
class ContentSliver<T> extends StatelessWidget {
  const ContentSliver({super.key, required this.load, required this.builder});

  final Future<T> Function() load;
  final Widget Function(BuildContext context, T data) builder;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ContentCubit<T>(load),
      child: BlocBuilder<ContentCubit<T>, ContentState<T>>(
        builder: (context, state) => switch (state) {
          ContentLoaded<T>(:final data) => builder(context, data),
          ContentFailed<T>(:final message) => SliverToBoxAdapter(
            child: ErrorView(
              message: message,
              onRetry: context.read<ContentCubit<T>>().load,
            ),
          ),
          ContentLoading<T>() => const SliverToBoxAdapter(child: LoadingView()),
        },
      ),
    );
  }
}
