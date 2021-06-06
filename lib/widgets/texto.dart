import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Titulo extends StatelessWidget {
 
 String? texto;
 double size;
 Color? color;
 EdgeInsetsGeometry padding;

 Titulo({required this.texto,required this.size, required this.color,required this.padding});
 
 //Widget titulo(String texto, double size, Color color, EdgeInsetsGeometry padding) 
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: this.padding,
      child: SelectableText(
        this.texto!,
        style: TextStyle(color: this.color, fontSize: this.size, fontWeight: FontWeight.w300),  
      ),
    );
   
  }
}