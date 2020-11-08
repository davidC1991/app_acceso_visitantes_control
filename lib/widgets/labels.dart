import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  final String ruta;
  final String mensaje1;
  final String ingresa;


  const Labels({
    Key key,
    @required this.ruta,
    this.mensaje1,
    this.ingresa
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(this.mensaje1, style: TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.w300)),
          SizedBox(height: 10,),
          GestureDetector(
           onTap: (){
             Navigator.pushReplacementNamed(context, this.ruta);
           },
            child: Text(this.ingresa, style: TextStyle(color: Colors.blue[600], fontSize: 17, fontWeight: FontWeight.bold))),
          ],
      ),
    );
  }
}