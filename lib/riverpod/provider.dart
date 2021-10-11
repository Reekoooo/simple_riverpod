
import 'package:flutter/cupertino.dart';
import 'package:simple_river_pod/riverpod/scope.dart';



typedef Create = Listenable Function(Read read,Watch watch);

class Provider with ChangeNotifier{
  final Create create;
  Provider(this.create);

  void notify(){
    notifyListeners();
  }
}