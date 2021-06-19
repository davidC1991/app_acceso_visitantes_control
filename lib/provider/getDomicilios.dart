

import 'package:acceso_residencial/main.dart';
import 'package:flutter/foundation.dart';
import 'package:acceso_residencial/models/domiciliosModel.dart';

class GetDomicilios with ChangeNotifier{

  List<DomicilioDatos> _listDomicilios=[]; 
  DomicilioDatos? domicilio;
  String _loading='buscarDatos';
  
  List<DomicilioDatos>  get listDomicilios => this._listDomicilios;
  String get loading=>this._loading;

   
   
   set setLoading(String sx){
    this._loading=sx;
    notifyListeners();
  }

  getDomiciliosActivos(String codigoPrincipal,String codigoCorreo)async{
      Map<String,dynamic> dicc_={};
      //print(codigoPrincipal);
      
      try {
         //this._loading='cargando';
         //notifyListeners();
         this._listDomicilios.clear();
         await domicilios.doc(codigoPrincipal).collection(codigoCorreo).orderBy('fecha',descending: false).get().then((value) {
         print('----------------------------------------------------------------');
         print('datos domicilios: ${value.docs[0].id}');
         
        // if (value.docs!=[]){
         value.docs.forEach((element) { 
           dicc_=element.data();
           dicc_['idDomicilio']=element.id;
           this.domicilio=domicilioFromJson(dicc_);
           this._listDomicilios.add(domicilio!);
         
          });
          this._loading='buscarDatos';
          notifyListeners();
         
      });
      
      } catch (e) {
        print('no hay datos');
        this._loading='no hay datos';
        notifyListeners();
      }
      
      
  }

}