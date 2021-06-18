import 'package:flutter/material.dart';

class DomicilioPage extends StatefulWidget {
  const DomicilioPage({ Key? key }) : super(key: key);

  @override
  _DomicilioPageState createState() => _DomicilioPageState();
}

class _DomicilioPageState extends State<DomicilioPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: titulo('Crea codigos para domicilios',15.0, Colors.blue[600],EdgeInsets.only(left: 0,bottom: 15,right: 10,top: 20)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:(){},
      ),
      
    );
    
  }

  Widget titulo(String texto, double size, Color? color, EdgeInsetsGeometry padding) { 
    return Padding(
      padding: padding,
      child: Text(
        texto,
        style: TextStyle(color: color, fontSize: size, fontWeight: FontWeight.w300),  
      ),
    );
   }
}