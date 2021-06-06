import 'package:acceso_residencial/main.dart';
import 'package:acceso_residencial/models/historialQrModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';



class GetHistorialQr with ChangeNotifier{

  // ignore: deprecated_member_use
  List<HistorialQr> _listQr=[];
  // ignore: non_constant_identifier_names
  List<Map<String,dynamic>> list_datos=[];
  // ignore: non_constant_identifier_names
  HistorialQr? dicc_qr;
  String _loading='cargando';
  
  List<HistorialQr>  get listQr => this._listQr;
  String get loading=>this._loading;


  set setLoading(String sx){
    this._loading=sx;
    notifyListeners();
  }

  // getHistorialQrUsuario(String codigoPrincipal,String codigoCorreo)async{
     
  //    // ignore: missing_return
  //    //QuerySnapshot datos= await historialQr.doc(codigoPrincipal).collection(codigoCorreo).get();
  //    // ignore: non_constant_identifier_names
  //    List<Map<String,dynamic>> list_=[];
  //    //this._listQr.clear();
  //    DocumentSnapshot datos=  await historialQr.doc(codigoPrincipal).get();
  //    DocumentReference datosCompletos=  historialQr.doc(codigoPrincipal);
  //    print('----------------------------------');
  //    print(codigoPrincipal);
  //    //print(datos.data());
  //    //print(datosCompletos.collection(datos.data()['ids'][0]).get());
  //    //print(datos.docs[0].data());
  //   //  this.listQr.clear();
  //    print('lista de diccionarios actuales');
  //     // ignore: non_constant_identifier_names
  //     List<Timestamp>list_fechas=[];
  //     if(datos.data()!=null){
  //       this._listQr.clear();
  //       list_datos.clear();
  //       print(datos.data()['ids'].length);
  //       for (var i = 0; i < datos.data()['ids'].length; i++) {
  //          await datosCompletos.collection(datos.data()['ids'][i]).orderBy('fecha',descending: true).get().then((value) {
            
  //           //this.dicc_qr=null;
  //           value.docs.forEach((element) { 
              
  //             list_fechas.add(element['fecha']);
  //             list_datos.add(element.data());
             
  //           });
          
  //        });
         
  //       }
  //       list_fechas.sort();
  //       var reversedList = new List.from(list_fechas.reversed);
       
  //       print('---------------------------------------');
  //       print(list_datos.length);
  //       print(reversedList.length);
       
  //         reversedList.forEach((fecha){
  //            list_datos.forEach((element){
  //              if (element['fecha']==fecha){
  //               //print('${fecha.toDate()} -- ${element['fecha'].toDate()}'); 
  //               list_.add(element); 
  //               }
  //         });
  //       });
           
  //       list_.forEach((element) { 
  //          //print('${element['fecha'].toDate()}'); 
  //          this.dicc_qr=codigoQrFromJson(element);
  //          this._listQr.contains(this.dicc_qr)?print(''):this._listQr.add(this.dicc_qr); 
  //       });       
          
  //       this._loading='cargado';
  //       notifyListeners();
         
  //     }else{
  //       this._loading='no hay datos';
  //       notifyListeners();
  //     }         
  //  }
}