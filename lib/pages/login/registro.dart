import 'package:acceso_residencial/helpers/alertasRapidas.dart';
import 'package:acceso_residencial/helpers/mostrar_alertas.dart';
import 'package:acceso_residencial/pages/login.dart';
import 'package:acceso_residencial/provider/validacion.dart';
import 'package:acceso_residencial/services/Usuario_Validacion.dart';
import 'package:acceso_residencial/widgets/custom_input.dart';
import 'package:acceso_residencial/widgets/labels.dart';
import 'package:acceso_residencial/widgets/texto.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';

class RegistroUsuario extends StatefulWidget {
  RegistroUsuario({Key key}) : super(key: key);

  @override
  _RegistroUsuarioState createState() => _RegistroUsuarioState();
}

class _RegistroUsuarioState extends State<RegistroUsuario> {
  TextEditingController nombres= TextEditingController();
  TextEditingController apellidos= TextEditingController();
  TextEditingController correo= TextEditingController();
  TextEditingController celular= TextEditingController();
  TextEditingController contrasenha= TextEditingController();
  TextEditingController repitaContrasenha= TextEditingController();
  TextEditingController codigoResidente= TextEditingController();
  UsuarioProvider usuarioRegistro=UsuarioProvider();
  
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Titulo(texto: 'INGRESE SU INFORMACION PERSONAL', size: 20, color: Colors.black45, padding: EdgeInsets.only(left: 20,bottom: 45,right: 10,top: 60)),
            CustomInput(icon:Icons.person,placeholder:'Nombres', textController:nombres,keyboardType:TextInputType.text,isPassword: false), 
            CustomInput(icon:Icons.person,placeholder:'Apellidos', textController:apellidos,keyboardType:TextInputType.text,isPassword: false), 
            CustomInput(icon:Icons.phone_android,placeholder:'Celular', textController:celular,keyboardType:TextInputType.text,isPassword: false), 
            CustomInput(icon:Icons.email,placeholder:'Correo', textController:correo,keyboardType:TextInputType.text,isPassword: false), 
            CustomInput(icon:Icons.ac_unit,placeholder:'Contraseña', textController:contrasenha,keyboardType:TextInputType.text,isPassword: true), 
            CustomInput(icon:Icons.blur_on,placeholder:'Repita la contraseña', textController:repitaContrasenha,keyboardType:TextInputType.text,isPassword: true), 
            CustomInput(icon:Icons.code,placeholder:'Codigo de residente', textController:codigoResidente,keyboardType:TextInputType.text,isPassword: true), 
            SizedBox(height:size.height*0.02),
            boton('Registrarse', context),
            SizedBox(height:size.height*0.02),
            Labels(ruta:'login',mensaje1:'¿Ya tienes una cuenta?',ingresa:'Iniciar sesión')
             
            
          ],
        ),
      )
    );
  }

   Widget boton(String texto, BuildContext context) {
     
     final validacion= Provider.of<Validacion>(context, listen: false);
     return Padding(
       padding: const EdgeInsets.all(8.0),
       child: FlatButton(
              padding: EdgeInsets.all(15.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                side: BorderSide(color: Colors.blue.withOpacity(0.5), width: 3.0)
              ),
              onPressed: () async{
                if(texto=='Iniciar sesión'){  
                  Navigator.pushReplacementNamed(context, 'login');
                }
                if(texto=='Registrarse'){
                   if(nombres.text.isNotEmpty  &&
                      apellidos.text.isNotEmpty&&
                      correo.text.isNotEmpty  &&
                      celular.text.isNotEmpty  &&
                      contrasenha.text.isNotEmpty  &&
                      repitaContrasenha.text.isNotEmpty  &&
                      codigoResidente.text.isNotEmpty 
                      ){
                      
                      if(EmailValidator.validate(correo.text)){
                      
                      await verificarCodigo(validacion,codigoResidente.text);
                      print('____codigo ingresado____________>${codigoResidente.text}');
                      if(validacion.isUsser){
                         Map<String, dynamic> info = await usuarioRegistro.nuevoUsuario(correo.text, contrasenha.text);
                          
                           print(info);
                         //id=info['id'];
                          if (info['ok']){
                              // Navigator.pushReplacementNamed(context, 'LoginPage');
                                //usersRef.doc(info['id']).set({
                                usersRef.doc(info['id']).set({
                                'idCorreo'              :info['id'],
                                'fotoUrl'               :'',
                                'correoRegistro'        :correo.text,
                                'timeStamp'             :timestamp,
                                'tipoUsuario'           :validacion.datosUsuario.role,
                                'celular'               :validacion.datosUsuario.celular,
                                'torre'                 :validacion.datosUsuario.torre,
                                'apartamento'           :validacion.datosUsuario.apartamento,
                                'nombre'                :validacion.datosUsuario.nombre,
                                'apellidos'             :validacion.datosUsuario.apellidos,
                                'correo'                :validacion.datosUsuario.correo,
                                'nombreRegistro'        :nombres.text,
                                'apellidosRegistro'     :apellidos.text,
                                'celularRegistro'       :celular.text,
                                'contraseña'            :contrasenha.text,
                                'tokenPrincipal'        :codigoResidente.text
                                
                              });

                              nombres.clear();
                              apellidos.clear();
                              celular.clear();
                              correo.clear();
                              contrasenha.clear();
                              repitaContrasenha.clear();
                              celular.clear();
                              codigoResidente.clear();

                              mensajePantalla('Registro de usuario exitoso!');
                          }else{
                              mostrarAlerta(context,'Reporte',info['mensaje']);
                          }
                      }else{
                         mensajePantalla('token incorrecto!');
                      }
                     }else{
                       mensajePantalla('Correo invalido!');
                     } 
                    }else{
                      mensajePantalla('LLene todo los campos!'); 
                    }
                  }
                },
              child: Text(texto)
            ),
     );
  }

verificarCodigo(final validacion, String codigo)async{
    await validacion.getValidarUsuario(codigo);
    //print('${validacion.datosUsuario}');
    print('${validacion.isUsser}');
  }


}