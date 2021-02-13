UsuarioDatos usuarioFromJson(Map<String, dynamic> str) => UsuarioDatos.fromJson(str);



class UsuarioDatos {
    UsuarioDatos({
        this.nombre,          
        this.apellidos,       
        this.torre,           
        this.apartamento,     
        this.role,            
        this.celular,         
        this.correo,          
        this.correoRegistro,  
        this.fotoUrl,         
        this.idCorreo,        
        this.celularRegistro,  
        this.tokenPrincipal,   
        this.contrasenha,      
        this.apellidosRegistro, 
        this.nombreRegistro,    
        this.timeStamp,         

        
        
    });

    String nombre;
    String apellidos;
    String torre;
    String apartamento;
    String role;
    String celular;
    String correo;
    String correoRegistro;
    String fotoUrl;
    String idCorreo;
    String celularRegistro;  
    String tokenPrincipal;  
    String contrasenha;   
    String apellidosRegistro; 
    String nombreRegistro;    
    String timeStamp;  

    factory UsuarioDatos.fromJson(Map<String, dynamic> json) => UsuarioDatos(
        nombreRegistro    : json["nombreRegistro"],
        apellidosRegistro : json["apellidosRegistro"],
        fotoUrl           : json['fotoUrl'],
        idCorreo          : json['idCorreo'],
        role              : json["tipoUsuario"],
        celularRegistro   : json["celularRegistro"],
        
       
        nombre            :json["nombre"],
        apellidos         :json["apellidos"],
        torre             :json["torre"],
        apartamento       :json["apartamento"],
        celular           :json["celular"],
        correo            :json["correo"],
        correoRegistro    :json['correoRegistro'],
        tokenPrincipal    :json['tokenPrincipal'],
        
         
        
    );
    
    }