import 'package:acceso_residencial/preferencias/preferencias_usuarios.dart';
import 'package:acceso_residencial/provider/animation.dart';
import 'package:acceso_residencial/provider/crearCodigo.dart';
import 'package:acceso_residencial/provider/getDatosUsurio.dart';
import 'package:acceso_residencial/provider/getDomicilios.dart';
import 'package:acceso_residencial/provider/getHistorialQr.dart';
import 'package:acceso_residencial/provider/navegacion.dart';
import 'package:acceso_residencial/provider/validacion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:acceso_residencial/routes/routes.dart';
import 'package:provider/provider.dart';

final codigos=FirebaseFirestore.instance.collection('codigos');
final usuarios=FirebaseFirestore.instance.collection('usuarios');
final historialQr=FirebaseFirestore.instance.collection('historialQr');
final domicilios=FirebaseFirestore.instance.collection('domicilios');


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create:(_)=>AnimationApp()),
        ChangeNotifierProvider(create:(_)=>Validacion()),
        ChangeNotifierProvider(create:(_)=>Crearcodigo()),
        ChangeNotifierProvider(create:(_)=>GetDatosUsuario()),
        ChangeNotifierProvider(create:(_)=>NavegacionModel()),
        ChangeNotifierProvider(create:(_)=>GetHistorialQr()),
        ChangeNotifierProvider(create:(_)=>GetDomicilios()),
      ],
     
      child: MaterialApp(
         
          debugShowCheckedModeBanner: false,
          title: 'Acceso',
          initialRoute: 'login',
          routes: appRoutes,
          ),
    );
    
  }
}
       
        

