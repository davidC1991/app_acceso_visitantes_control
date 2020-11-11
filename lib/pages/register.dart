

import 'dart:async';

import 'package:acceso_residencial/widgets/custom_input.dart';
import 'package:acceso_residencial/widgets/texto.dart';

import 'package:flutter/material.dart';


class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {


  TextEditingController nombreUsuario= TextEditingController();
  TextEditingController codigoMaster= TextEditingController();
  final _sacaffolddKey = GlobalKey<ScaffoldState>();


  String username;
 
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _sacaffolddKey,
      body: ListView(
        children: [
          Titulo(texto:'Ingrese los siguientes datos',size:15.0, color:Colors.blue[600],padding:EdgeInsets.only(left: 10,bottom: 15,right: 10,top: 20)),
          CustomInput(icon:Icons.person,placeholder:'Nombres *', textController:nombreUsuario,keyboardType:TextInputType.text,isPassword: false), 
          //formRegistro(nombreUsuario, 'usuario','Escriba su nombre de usuario',_formKeyUsaurio),
         // formRegistro(codigoMaster, 'codigo','Escriba su codigo de registro',_formKeyCodigo),
          botonRegistrar()
        ],
      )
   );
  }

  GestureDetector botonRegistrar() {
    return GestureDetector(
               onTap:(){
                  SnackBar snackbar =SnackBar(content: Text('Bienvenido ${nombreUsuario.text}'));
                  _sacaffolddKey.currentState.showSnackBar(snackbar);
                  Timer(Duration(seconds: 2), (){
                    Navigator.pop(context, nombreUsuario.text.toString());
                  });
                
               },
               child: Container(
                 height: 50.0 ,
                 width: 350.0,
                 decoration: BoxDecoration(
                   color: Colors.blue,
                   borderRadius: BorderRadius.circular(7.0),
                 ),
                 child: Center(
                   child: Text('Validar', style: TextStyle(color: Colors.white,fontSize: 15.0,fontWeight: FontWeight.bold))),
               ),
             );
  }


}
                                  



/*  import 'dart:async';


import 'package:flutter/material.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _sacaffolddKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey <FormState>();
  TextEditingController nombreUsuario= TextEditingController();
  String username;

  submit(){

    final form = _formKey.currentState;

    if (form.validate()){
       form.save();
       SnackBar snackbar =SnackBar(content: Text('Bienvenido $username'));
       _sacaffolddKey.currentState.showSnackBar(snackbar);
       Timer(Duration(seconds: 2), (){
         Navigator.pop(context, username);
       });
    }
  }
       
   

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _sacaffolddKey,
      //appBar: header(context, textoTitulo: 'establece tu perfil', removeBackButton: true),
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 25.0), 
                    child: Center(
                      child: Text('', style: TextStyle(fontSize: 25.0)),
                  ),
                ),
                //formRegistro('usuario','Escriba su nombre de usuario',_formKeyUsaurio),
               Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Container(
                    child: Form(
                      key: _formKey,
                      autovalidate: true,
                      child: TextFormField(
                        validator: (val){
                          if(val.trim().length < 3 || val.isEmpty){
                            return 'Codigo muy corto';
                          }else if (val.trim().length > 12){
                            return 'Codigo muy largo';
                          }else {
                            return null;
                          }
                        },
                        onSaved: (val) => username=val ,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Codigo de residente',
                          labelStyle: TextStyle(fontSize: 15.0),
                          hintText: 'Ingrese el codigo que le envio el administrador', 
                        )
                      ) ,
                    )
                  ),
                ), 
               GestureDetector(
                 onTap:submit,
                 child: Container(
                   height: 50.0 ,
                   width: 350.0,
                   decoration: BoxDecoration(
                     color: Colors.blue,
                     borderRadius: BorderRadius.circular(7.0),
                   ),
                   child: Center(
                     child: Text('Validar', style: TextStyle(color: Colors.white,fontSize: 15.0,fontWeight: FontWeight.bold))),
                                 
                 ),
               )
                 
                    
              ],
            )),
        ],
      ),

    );
  }

   
}                                  */