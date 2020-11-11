import 'package:acceso_residencial/widgets/texto.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';


class ScanPage extends StatefulWidget {

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String qrResult='No hay resultados aun!';
  bool isValidQR=true;
  
   Widget imagenQr(double alto){
    
     return  Container(
              height: alto*0.3,
              width: 200,
              child: Image(image:AssetImage('assets/codigo-qr.png')),
             );
   } 
               

  @override
  Widget build(BuildContext context) {
    final alto= MediaQuery.of(context).size.height;
  
    return Scaffold(
       appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: Titulo(texto:'Verificar visitantes',size:15.0, color:Colors.blue[600],padding:EdgeInsets.only(left: 0,bottom: 15,right: 10,top: 20)),
        actions: [
            GestureDetector(
            onTap: (){
              setState(() {});
            },
            child: Titulo(texto:'Limpiar',size:15.0, color:Colors.red[600],padding:EdgeInsets.only(left: 0,bottom: 15,right: 10,top: 20)),
           ),
        ],
      ),
              
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          //mainAxisAlignment: MainAxisAlignment.end,
          //mainAxisSize: MainAxisSize.max,
          children: [
            //Text('RESULT',textAlign: TextAlign.center,),
            isValidQR?SizedBox(height: alto*0.04):Container(),
            isValidQR?informacionDelQr():imagenQr(alto),
            SizedBox(height: alto*0.1),
            isValidQR?imagenVerificado(alto):
            Center(child: Titulo(texto:'Veririfique el codigo QR del visitante!',size:20.0, color:Colors.black87,padding:EdgeInsets.only(left: 0,bottom: 15,right: 10,top: 20))),
            SizedBox(height: alto*0.05),
            scanQr()
            
          ],
        ),
      ),
   );
  }
           
  Widget imagenVerificado(double alto){
    return  Container(
              height: alto*0.1,
              width: 200,
              child: Image(image:AssetImage('assets/comprobar.png')),
             );
  }

  Widget informacionDelQr(){
    return Container(
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Divider(height: 10.0,),
          Titulo(texto:'PROPIETARIO',size:20.0, color:Colors.black45,padding:EdgeInsets.only(left: 10,bottom: 0,right: 10,top: 0)),
          Divider(),
          Titulo(texto:'Nombre: Jesus Edilberto Callejas',size:15.0, color:Colors.black87,padding:EdgeInsets.only(left: 10,bottom: 5,right: 10,top: 0)),
          Titulo(texto:'Apartamento: 801',size:15.0, color:Colors.black87,padding:EdgeInsets.only(left: 10,bottom: 5,right: 10,top: 0)),
          Titulo(texto:'Torre: 4',size:15.0, color:Colors.black87,padding:EdgeInsets.only(left: 10,bottom: 5,right: 10,top: 0)),
          Titulo(texto:'Celular: 3003456789',size:15.0, color:Colors.black87,padding:EdgeInsets.only(left: 10,bottom: 15,right: 10,top: 0)),
          Divider(height: 10.0,),
          Titulo(texto:'VISITANTE',size:20.0, color:Colors.black45,padding:EdgeInsets.only(left: 10,bottom: 5,right: 10,top: 0)),
          Divider(height: 10.0,),
          Titulo(texto:'Nombre: Julio Ernesto',size:15.0, color:Colors.black87,padding:EdgeInsets.only(left: 10,bottom: 5,right: 10,top: 0)),
          Titulo(texto:'Apellidos: Jaramillo Rodriguez',size:15.0, color:Colors.black87,padding:EdgeInsets.only(left: 10,bottom: 5,right: 10,top: 0)),
          Titulo(texto:'Cantidad de personas: 5',size:15.0, color:Colors.black87,padding:EdgeInsets.only(left: 10,bottom: 5,right: 10,top: 0)),
          Titulo(texto:'Dias de validez: 3',size:15.0, color:Colors.black87,padding:EdgeInsets.only(left: 10,bottom: 5,right: 10,top: 0)),
          Titulo(texto:'Zona de labores: No aplica',size:15.0, color:Colors.black87,padding:EdgeInsets.only(left: 10,bottom: 5,right: 10,top: 0)),
          Divider(height: 10.0,),
        ],
      ),
    );
  }
           
    
         
            


  Widget scanQr()  {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FlatButton(
              padding: EdgeInsets.all(15.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                side: BorderSide(color: Colors.blue.withOpacity(0.5), width: 3.0)
              ),
              onPressed: ()async{
                String scaning =  await BarcodeScanner.scan();
                 
                 qrResult=scaning;
                 print(qrResult);
                 setState(() {
                  
                 }); 
                 
              },
              child: Text('Escanear codigo Qr')
            ),
    );
  }
}