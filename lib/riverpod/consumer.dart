import 'package:flutter/material.dart';
import 'package:simple_river_pod/riverpod/provider.dart';
import 'package:simple_river_pod/riverpod/scope.dart';

typedef ConsumerBuilder = Widget Function(Watch watch);

class Consumer extends StatefulWidget {
  final ConsumerBuilder builder;

  const Consumer({Key? key, required this.builder}) : super(key: key);

  @override
  _ConsumerState createState() => _ConsumerState();
}

class _ConsumerState extends State<Consumer> {
  final Set<Provider> watched = {};

  Listenable watch(Provider provider) {
    final Listenable state = context
        .dependOnInheritedWidgetOfExactType<Scope>()!
        .read(provider);
    if (!watched.contains(provider)) {
      watched.add(provider);
      provider.addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
    }
    return state;
  }

  void rebuildTree(Element el) {
    el.markNeedsBuild();
    el.visitChildren(rebuildTree);
  }

  @override
  Widget build(BuildContext context) {
    (context as Element).visitChildren(rebuildTree);
    return widget.builder( watch);
  }
}
