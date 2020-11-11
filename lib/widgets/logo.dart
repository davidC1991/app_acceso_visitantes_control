import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final String titulo;

  const Logo({Key key, this.titulo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.only(top:70),
        width: 340,
        child: Center(
          child: Column(
            children: [
              Image(image:AssetImage('assets/logo.png')),
              SizedBox(height:20.0),
              Text(this.titulo)

            ],
          ),
        ),
      ),
    );
  }
}
