import 'dart:async';

import 'package:acceso_residencial/helpers/alertasRapidas.dart';
import 'package:acceso_residencial/helpers/mostrar_alertas.dart';
import 'package:acceso_residencial/provider/animation.dart';
import 'package:acceso_residencial/provider/getDatosUsurio.dart';

import 'package:acceso_residencial/services/Usuario_Validacion.dart';
import 'package:acceso_residencial/widgets/custom_input.dart';
import 'package:acceso_residencial/widgets/labels.dart';
import 'package:acceso_residencial/widgets/texto.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';

import 'package:acceso_residencial/widgets/logo.dart';

import 'package:provider/provider.dart';




final GoogleSignIn gSignIn= GoogleSignIn();
final usersRef=FirebaseFirestore.instance.collection('usuarios');

final DateTime timestamp= DateTime.now();


// ignore: must_be_immutable
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  final _sacaffolddKey = GlobalKey<ScaffoldState>();
  UsuarioProvider usuarioRegistro=UsuarioProvider();
  bool cargando =false;
  String id='';
  Map<String,dynamic> datosUsuarioLogeado= new Map();
  TextEditingController correo= TextEditingController();
  TextEditingController contrasenha= TextEditingController();

  void initState(){
    
    super.initState();
   _controller = new AnimationController(vsync: this);
   _controller.duration=Duration(milliseconds: 3000);
   
  }
  
   @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
    


  @override
  Widget build(BuildContext context) {
   if(_controller.isCompleted){ print('termno aanimaicno');}
    return Scaffold(
       key: _sacaffolddKey,
       backgroundColor: Colors.white,
       body:  pantallaLogin(context),
   );
  }
      

 

  Widget pantallaLogin(BuildContext context) {
    final stateLoading=Provider.of<AnimationApp>(context, listen: false);
    Size size=MediaQuery.of(context).size;
    return Stack(
      children: [
        
        SingleChildScrollView(
          child: Column(
            
            //mainAxisAlignment: MainAxisAlignment.start,
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Logo(titulo:''),
              SizedBox(height:size.height*0.01),
              //Titulo(texto: 'Iniciar sesión', size: 15, color: Colors.blue[300], padding: EdgeInsets.only(left: 10,bottom: 5,right: 10,top: 0)),
              //SizedBox(height:size.height*0.06),
              Container(
                width: size.width*0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Titulo(texto: 'Correo', size: 15, color: Colors.blue[300], padding: EdgeInsets.only(left: 10,bottom: 5,right: 10,top: 0)),
                    CustomInput(icon:Icons.email,placeholder:'ejemplo@hotmail.com', textController:correo,keyboardType:TextInputType.text,isPassword: false),
                  ],
                )), 
              Container(
                width: size.width*0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Titulo(texto: 'Contraseña', size: 15, color: Colors.blue[300], padding: EdgeInsets.only(left: 10,bottom: 5,right: 10,top: 0)),
                    CustomInput(icon:Icons.adjust,placeholder:'* * * * *', textController:contrasenha,keyboardType:TextInputType.text,isPassword: true),
                  ],
                )),
                SizedBox(height:size.height*0.02),
                boton('Ingresar',context, size),
                Labels(ruta:'registroCorreo',mensaje1:'¿Aun no tienes cuenta?',ingresa:'Registrarse')
                //boton('Registrarse',context, size)
              
            ],
          ),
        ),
        
       stateLoading.cargando?widgetCargando(stateLoading):Container()
      ],
    );
  }
       
   widgetCargando(final stateLoading){
     
     Timer(Duration(seconds: 2), (){
     //  _controller.stop();
       stateLoading.cargandoA(false);
       validarUsuario();
       
       
     });
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.blue[100].withOpacity(0.3),
      child: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 100),
            Lottie.asset(
              'assets/38321-loading.json',
              width: 100,
              height: 100,
              fit: BoxFit.fill,
              //controller: _controller,
              onLoaded: (co) {
                //_controller.forward();
                 
               },
             
              ),
          ],
        ),
      ),
    );
  }

   obtenerDatosUsuario(final datosUsuarioAll,String id)async{
    await datosUsuarioAll.conseguirDatosUsuario(id);
    print('${datosUsuarioAll.datosCompletosUsuario.nombre}');
    //print('${validacion.isUsser}');
  }

   validarUsuario()async{
    
    final datosUsuarioAll = Provider.of<GetDatosUsuario>(context, listen: false);
    

     if(correo.text.isNotEmpty  && contrasenha.text.isNotEmpty){
          Map info = await usuarioRegistro.login(correo.text,contrasenha.text);
          print(info);  
          if (info['ok']){
            id=info['id'];
            await obtenerDatosUsuario(datosUsuarioAll,id);
            //print(datosUsuarioAll.datosCompletosUsuario.celularRegistro);
            SnackBar snackbar =SnackBar(content: Text('Bienvenido señor@ ${datosUsuarioAll.datosCompletosUsuario.nombreRegistro} ${datosUsuarioAll.datosCompletosUsuario.apellidosRegistro}'));
                _sacaffolddKey.currentState.showSnackBar(snackbar);
               Timer(Duration(seconds: 2), (){
                 if(datosUsuarioAll.datosCompletosUsuario.role=='Portero'){
                    Navigator.pushReplacementNamed(context, 'scan');
                 }else if(datosUsuarioAll.datosCompletosUsuario.role=='administrador'){
                    Navigator.pushReplacementNamed(context, 'admin');
                 }else if(datosUsuarioAll.datosCompletosUsuario.role=='Residente'){
                    Navigator.pushReplacementNamed(context, 'home');
                 }
               }); 
          }else{
            mostrarAlerta(context,'Reporte',info['mensaje']);
          }    
     }else{
       mensajePantalla('LLene todo los campos!');
     }
   }
    
    Widget boton(String texto, BuildContext context,Size size) {
     final stateLoading=Provider.of<AnimationApp>(context, listen: false);
     return Padding(
       padding: const EdgeInsets.all(8.0),
       child: Container(
         width: size.width*0.7,
         child: FlatButton(
                padding: EdgeInsets.all(15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(color: Colors.blue.withOpacity(0.5), width: 3.0)
                ),
                onPressed: () async{
                  //validarUsuario();
                  stateLoading.cargandoA(true);
                  FocusScope.of(context).requestFocus(new FocusNode());
                  setState(() { });
                },
                child: Text(texto)
              ),
       ),
          );
         }     

}


 