import 'package:acceso_residencial/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:acceso_residencial/models/usuario.dart';


class Validacion with ChangeNotifier{

  bool _isUsser=false;
  Usuario? _datosUsuario;
  String? _urlPhoto;
 
  bool get isUsser => this._isUsser;
  Usuario? get datosUsuario => this._datosUsuario;
  String? get urlPhoto => this._urlPhoto;
  

  void saveUrlPhoto(String url){
    this._urlPhoto= url;
    notifyListeners();
  }

  getValidarUsuario(String codigoIngresado)async{
     
     // ignore: missing_return
     DocumentSnapshot datos=  await codigos.doc(codigoIngresado).get();
     
     if(datos.exists){
        this._datosUsuario= usuarioFromJson(datos.data() as Map<String, dynamic>);
        this._isUsser=true;
        notifyListeners();
     }else{
        this._datosUsuario=null;
        this._isUsser=false;
        notifyListeners();
     }         
   }
}
    
     
     
      
                       
  
     