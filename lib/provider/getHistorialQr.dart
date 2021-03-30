import 'package:acceso_residencial/main.dart';
import 'package:acceso_residencial/models/historialQrModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:acceso_residencial/models/usuario.dart';


class GetHistorialQr with ChangeNotifier{

  List<HistorialQr> _listQr=new List<HistorialQr>();
  HistorialQr dicc_qr;
  
  List<HistorialQr>  get listQr => this._listQr;

  getHistorialQrUsuario(String codigoPrincipal,String codigoCorreo)async{
     
     // ignore: missing_return
     QuerySnapshot datos= await historialQr.doc(codigoPrincipal).collection(codigoCorreo).get();
     //print('----------------------------------');
     //print(codigoPrincipal);
     //print(codigoCorreo);
     //print(datos.docs[0].data());
     this.listQr.clear();
     if(datos.docs.isNotEmpty){
        datos.docs.forEach((element) { 
           this.dicc_qr=codigoQrFromJson(element.data());
           this._listQr.add(this.dicc_qr); 
        });
        //print(this.listQr);
        notifyListeners();
     }else{
        
     }         
   }
}