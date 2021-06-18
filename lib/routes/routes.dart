

import 'package:acceso_residencial/pages/admin.dart';
import 'package:acceso_residencial/pages/historial_acceso.dart';
import 'package:acceso_residencial/pages/home.dart';
import 'package:acceso_residencial/pages/login.dart';
import 'package:acceso_residencial/pages/login/registro.dart';
import 'package:acceso_residencial/pages/politicsPrivicy.dart';
import 'package:acceso_residencial/pages/register.dart';
import 'package:acceso_residencial/pages/scan.dart';
import 'package:flutter/material.dart';

final Map<String, Widget Function(BuildContext )> appRoutes={
  'home':           (_)=> HomePage(),
  'login':          (_)=> LoginPage(),
  'register':       (_)=> RegisterPage(),
  'historiaAcceso': (_)=> HistorialAccesoPage(),
  'scan':           (_)=> ScanPage(),
  'admin':          (_)=> AdminPage(),
  'registroCorreo': (_)=> RegistroUsuario(),
  'politicsAndPrivicy': (_)=> PoliticsAndPrivicy(),
  
};