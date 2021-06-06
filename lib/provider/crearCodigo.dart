
import 'package:flutter/foundation.dart';

class Crearcodigo with ChangeNotifier{

  bool _isCreatedCode= false;
  String? _actor='Portero';

  bool get isCreatedCode => this._isCreatedCode;
  String? get actor => this._actor;

  void createCode(bool crear){
    this._isCreatedCode=crear;
    notifyListeners();
  }
  void codeEnd(bool crear){
    this._isCreatedCode=crear;
    
  }

  void setActor(String? role){
    this._actor=role;
    notifyListeners();
  }


}