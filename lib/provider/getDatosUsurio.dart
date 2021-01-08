import 'package:acceso_residencial/main.dart';
import 'package:acceso_residencial/models/getDatosUsuarioModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class GetDatosUsuario with ChangeNotifier{
  UsuarioDatos _datosCompletosUsuario;
  bool _datosYaObtenidos= false;

  UsuarioDatos get datosCompletosUsuario => this._datosCompletosUsuario; 
  bool get datosYaObtenidos => this._datosYaObtenidos;

  conseguirDatosUsuario(String codigoCorreo)async{
    print('----------CONSEGUIR DATOS DEL USUARIO-----------');
     DocumentSnapshot datos=  await usuarios.doc(codigoCorreo).get();
     

     if(datos.exists){
        this._datosCompletosUsuario= usuarioFromJson(datos.data());
        //print(_datosCompletosUsuario.displayName);
        this._datosYaObtenidos=true;
        //this._isUsser=true;
        notifyListeners();
     }else{
        this._datosCompletosUsuario=null;
        this._datosYaObtenidos=false;
        //this._isUsser=false;
        notifyListeners();
     }         
  }
}