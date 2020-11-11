import 'package:acceso_residencial/provider/animation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:acceso_residencial/routes/routes.dart';
import 'package:provider/provider.dart';

final globalScaffoldKey=  GlobalKey<ScaffoldState>();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create:(_)=>AnimationApp())
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
       
        

