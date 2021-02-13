 
 
 
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void mensajePantalla(String mensaje) {
           Fluttertoast.showToast(
                  msg: mensaje,
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,
                  fontSize: 15,
                  backgroundColor: Colors.blue.withOpacity(0.7)
            );
}           