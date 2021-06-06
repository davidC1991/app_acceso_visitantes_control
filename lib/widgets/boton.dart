import 'package:acceso_residencial/provider/crearCodigo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Boton extends StatelessWidget {

  final String label;

  const Boton({
    Key? key,
    required this.label
  }):super(key:key);
  
  @override
  Widget build(BuildContext context) {
    final createCode= Provider.of<Crearcodigo>(context);
    return GestureDetector(
               onTap:(){
                  print('.....');
                  createCode.createCode(true);
               },
               child: Container(
                margin: EdgeInsets.all(10),
                 height: 50.0 ,
                 width: 300.0,
                 decoration: BoxDecoration(
                   color: Colors.blue,
                   borderRadius: BorderRadius.circular(7.0),
                 ),
                 child: Center(
                   child: Text(this.label, style: TextStyle(color: Colors.white,fontSize: 15.0,fontWeight: FontWeight.bold))),
               ),
             );
            }
  }
