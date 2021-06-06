
import 'package:acceso_residencial/provider/crearCodigo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DropDownWidget extends StatefulWidget {
  @override
  _DropDownWidgetState createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  static const opciones = [
    'Portero',
    'Residente',
    'administrador'
  ];

  final List<DropdownMenuItem<String>> dropDownMenuItems = opciones
      .map((String value) => DropdownMenuItem<String>(
            value: value,
            child: Container(
              decoration: BoxDecoration(
                //color: Colors.red,
                borderRadius: BorderRadius.circular(30)
              ),
             
              width: 340,
              height: 30,
              child: Padding(
                padding: const EdgeInsets.only(left: 45),
                child: Text(value, style: TextStyle(color: Colors.grey[600]),
            ),
              )),
          ))
      .toList();
  String? rutaId = 'Portero';
  
  
  @override
  Widget build(BuildContext context) {
    final createCode= Provider.of<Crearcodigo>(context);
    return DropdownButton(
            value: rutaId,
             onChanged: (String? newValue) {
              createCode.setActor(newValue);
              setState(() {
                rutaId = newValue;
              });
            }, 
            items: this.dropDownMenuItems,
    );
  }
}
             



