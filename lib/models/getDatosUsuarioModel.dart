UsuarioDatos usuarioFromJson(Map<String, dynamic> str) => UsuarioDatos.fromJson(str);



class UsuarioDatos {
    UsuarioDatos({
        this.nombre,
        this.apellidos,
        this.torre,
        this.apartamento,
        this.role,
        this.codigo,
        this.celular,
        this.correo,
        this.correoRegistro,
        this.displayName,
        this.fotoUrl,
        this.idCorreo,
        this.tipoUsuario
        
    });

    String nombre;
    String apellidos;
    String torre;
    String apartamento;
    String role;
    String codigo;
    String celular;
    String correo;
    String correoRegistro;
    String displayName;
    String fotoUrl;
    String idCorreo;
    String tipoUsuario;
   

    factory UsuarioDatos.fromJson(Map<String, dynamic> json) => UsuarioDatos(
        nombre: json["nombre"],
        apellidos: json["apellidos"],
        torre: json["torre"],
        apartamento: json["apartamento"],
        role: json["tipoUsuario"],
        codigo: json["codigo"],
        celular: json["celular"],
        correo: json["correo"],
        correoRegistro: json['correoRegistro'],
        displayName   : json['displayName'],
        fotoUrl       : json['fotoUrl'], 
        idCorreo      : json['idCorreo'],
        tipoUsuario   : json['tipoUsuario']
    );
    
    }