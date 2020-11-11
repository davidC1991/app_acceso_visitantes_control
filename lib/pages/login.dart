import 'dart:async';

import 'package:acceso_residencial/provider/animation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';

import 'package:acceso_residencial/widgets/logo.dart';
import 'package:acceso_residencial/pages/register.dart';
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
 
  bool cargando =false;
  String emailUsuario='';
  String displayName='';
  String fotoUrl='';
  String id='';

  void initState(){
    
    super.initState();

     gSignIn.isSignedIn().then((onValue){
      print('onvalue=$onValue');
      
    });
     
    // autentica o escucha cuando un usuario hace login
    gSignIn.onCurrentUserChanged.listen((gSigninAccount){
   
      emailUsuario=gSigninAccount.email;
      displayName=gSigninAccount.displayName;
      fotoUrl=gSigninAccount.photoUrl;
      id=gSigninAccount.id;
      validarUsuario();
      //controlSignIn(gSigninAccount);
    },onError: (gError){
      print("error message: "+ gError);
    });
    // reautenticar cuando la app es abierta otra vez, despues de haber iniciado sesion
    gSignIn.signInSilently(suppressErrors:false).then((gSignInAccount){
      
      emailUsuario=gSignInAccount.email;
      displayName=gSignInAccount.displayName;
      fotoUrl=gSignInAccount.photoUrl;
      id=gSignInAccount.id;
     // controlSignIn(gSignInAccount);
      print('-----');
      print(gSignInAccount);
      validarUsuario();
    }).catchError((gError){
      print("error message: "+ gError);
    }); 

    
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
   if(_controller.isCompleted){
               print('termno aanimaicno');
             }
    return Scaffold(
      //key: globalScaffoldKey,
      backgroundColor: Colors.white,
      body:  pantallaLogin(context),
   );
  }

 

  Widget pantallaLogin(BuildContext context) {
    final stateLoading=Provider.of<AnimationApp>(context, listen: false);
    return Stack(
      children: [
        
        SingleChildScrollView(
          child: Column(
            children: [
              Logo(titulo:''),
              
              SizedBox(height:150),
              botonLogin()
              
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
       Navigator.pushReplacementNamed(context, 'home');
     });
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.blue[100].withOpacity(0.8),
      child: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 160),
            Lottie.asset(
              'assets/waiting.json',
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

  botonLogin( ){
    return GestureDetector(
       onTap:loginUsser,
       child: Container(
         
         width: 290.0,
         height: 55.0,
         decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(15.0),
           image: DecorationImage(
             image: AssetImage('assets/entrarGoogle.png'),
             fit: BoxFit.cover,

           ),
         ), 
        // child:  Image(image:AssetImage('assets/googleSingin.png')),
       ),
      );
  }

  loginUsser(){
    print('Login');
    gSignIn.signIn();
    print(displayName);
   
  }

   validarUsuario()async{
    final stateLoading=Provider.of<AnimationApp>(context, listen: false);
    print(id);
    //Map<String,String> datosUsuario=Map();
    String datosUsuario;
    if(id!=''){
    DocumentSnapshot doc = await usersRef.doc(id).get();
    
    if (doc.exists){
      print('Usuario registrado');
     // AnimationApp.;
     
     stateLoading.cargandoA(true);
      //_controller.forward();
      setState(() {
        
      });
     // 
    }else{
      datosUsuario = await Navigator.push(context, MaterialPageRoute(
          builder: (context)=> RegisterPage())); 
      
     // await Navigator.pushNamed(globalScaffoldKey.currentContext, 'register');  
      

      print('________________>$datosUsuario');
     //await Navigator.pushNamed(context, 'register');                     
      
      usersRef.doc(id).set({
        'id'          :id,
        'displayName' :displayName,
        'fotoUrl'     :fotoUrl,
        'email'       :emailUsuario,
        'timeStamp'   :timestamp,
        'tipoUsuario' :'residente'
      });
      Navigator.pushReplacementNamed(context, 'home');

     }
     }  
      
     
     
  }
}