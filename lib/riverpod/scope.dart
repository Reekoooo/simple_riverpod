import 'package:flutter/cupertino.dart';
import 'package:simple_river_pod/riverpod/provider.dart';

typedef Read = Listenable Function(Provider provider);
typedef Watch = Listenable Function(Provider provider);
typedef CreateWatch = Watch Function();

class Scope extends InheritedWidget {
  final Map<Provider, Listenable> globalState = {};
  final Map<Provider, Set<Provider>> _watchMap = {};

  Listenable read(Provider provider) {
    return _getOrCreate(provider);
  }

  Watch createWatch(Provider providerListening) => (Provider provider) {
        final state = read(provider);
        if (!_watchMap[providerListening]!.contains(provider)) {
          _watchMap[providerListening]!.add(provider);
          provider.addListener(() {
            _recreateProvider(providerListening);
          });
        }
        return state;
      };

  Listenable _createProvider(provider){
    return  provider.create(read, createWatch(provider))
      ..addListener(provider.notify);
  }
  Listenable _getOrCreate(Provider provider) {
    _watchMap[provider] = {};
    return globalState.putIfAbsent(
        provider,
            () => _createProvider(provider));
  }

  Scope({Key? key, required Widget child}) : super(key: key, child: child);



  void _recreateProvider(Provider provider) {
    globalState[provider] = _createProvider(provider);
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}
