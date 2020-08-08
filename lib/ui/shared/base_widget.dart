import 'package:flutter/material.dart';
import 'package:music_player/core/utils/screen_utill.dart';
import 'package:provider/provider.dart';

class BaseWidget<T extends ChangeNotifier> extends StatefulWidget {
  final T model;
  final Widget child;
  final Function(T) initState;

  final Widget Function(BuildContext context, T model, Widget child) builder;

  BaseWidget({
    Key key,
    this.model,
    this.builder,
    this.initState,
    this.child,
  }) : super(key: key);

  _BaseWidgetState<T> createState() => _BaseWidgetState<T>();
}

class _BaseWidgetState<T extends ChangeNotifier> extends State<BaseWidget<T>> {
  // We want to store the instance of the model in the state
  // that way it stays constant through rebuilds
  T model;

  @override
  void initState() {
    // assign the model once when state is initialised
    model = widget.model;
    if (widget.initState != null) {
      widget.initState(model);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return ChangeNotifierProvider<T>(
      create: (context) => model,
      child: Consumer<T>(
        child: widget.child,
        builder: (context, model, child) =>
            widget.builder(context, model, child),
      ),
    );
  }
}
