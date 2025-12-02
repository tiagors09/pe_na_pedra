import 'package:flutter/widgets.dart';
import 'package:pe_na_pedra/provider/global_state.dart';

class GlobalStateProvider extends InheritedNotifier<GlobalState> {
  const GlobalStateProvider({
    super.key,
    required GlobalState notifier,
    required super.child,
  }) : super(notifier: notifier);

  static GlobalState of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<GlobalStateProvider>();

    assert(
      provider != null,
      'Não há GlobalStateProvider no contexto',
    );

    return provider!.notifier!;
  }
}
