// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);



Usuario usuarioFromJson(Map<String, dynamic> str) => Usuario.fromJson(str);



class Usuario {
    Usuario({
        this.nombre,
        this.apellidos,
        this.torre,
        this.apartamento,
        this.role,
        this.codigo,
        this.celular,
        this.correo,
        
    });

    String nombre;
    String apellidos;
    String torre;
    String apartamento;
    String role;
    String codigo;
    String celular;
    String correo;
   

    factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        nombre: json["nombre"],
        apellidos: json["apellidos"],
        torre: json["torre"],
        apartamento: json["apartamento"],
        role: json["tipoUsuario"],
        codigo: json["codigo"],
        celular: json["celular"],
        correo: json["correo"],
        
    );

   
}
