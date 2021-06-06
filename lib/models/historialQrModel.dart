import 'package:cloud_firestore/cloud_firestore.dart';

HistorialQr codigoQrFromJson(Map<String, dynamic> str) => HistorialQr.fromJson(str);



class HistorialQr {
    HistorialQr({
                  
        this.apellidosAcceso,       
        this.apellidosVisitantes,           
        this.fecha,     
        this.idAcceso,            
        this.nombreAcceso,         
        this.nombreVisitante,          
              
        
    });

    String? apellidosAcceso;      
    String? apellidosVisitantes;           
    Timestamp? fecha;
    String? idAcceso;            
    String? nombreAcceso;      
    String? nombreVisitante;

    factory HistorialQr.fromJson(Map<String, dynamic> json) => HistorialQr(
        apellidosAcceso      : json["apellidoAcceso"],
        apellidosVisitantes  : json["apellidosVisitante"],
        fecha                : json['fecha'],
        idAcceso             : json['idAcceso'],
        nombreAcceso         : json["nombreAcceso"],
        nombreVisitante      : json["nombreVisitante"],
             
    );
    
    }