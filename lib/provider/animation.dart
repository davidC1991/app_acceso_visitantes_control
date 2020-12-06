

import 'package:flutter/foundation.dart';

class AnimationApp with ChangeNotifier{
  bool _cargando= false;

  bool get cargando=> this._cargando;

  void cargandoA(bool valor){
    this._cargando=valor;
    notifyListeners();
  }

}