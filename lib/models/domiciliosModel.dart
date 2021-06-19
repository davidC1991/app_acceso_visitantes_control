import 'package:cloud_firestore/cloud_firestore.dart';

DomicilioDatos domicilioFromJson(Map<String, dynamic> str) => DomicilioDatos.fromJson(str);



class DomicilioDatos {
    DomicilioDatos({
        this.apartamento,          
        this.empresaDomicilio,       
        this.torre,           
        this.idCorreo,        
        this.tokenPrincipal,   
        this.timeStamp,         
        this.idDomicilio,         

        
        
    });

    
    String? torre;
    String? apartamento;
    String? idCorreo;
    String? tokenPrincipal;  
    Timestamp? timeStamp;  
    String? empresaDomicilio;  
    String? idDomicilio;  

    factory DomicilioDatos.fromJson(Map<String, dynamic> json) => DomicilioDatos(
       
        idCorreo          :json['idCorreo'],
        torre             :json["torre"],
        apartamento       :json["apto"],
        tokenPrincipal    :json['tokenPrincipal'],
        empresaDomicilio  :json['empresaDomicilio'],
        idDomicilio       :json['idDomicilio'],
        timeStamp         :json['fecha'],
        
         
        
    );
    
    }