import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';


class ScanPage extends StatefulWidget {

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String qrResult='No hay resultados aun!';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('RESULT',textAlign: TextAlign.center,),
            SizedBox(height: 5.0,),
            Text(qrResult,textAlign: TextAlign.center,),
            SizedBox(height: 25.0,),
            scanQr(qrResult)
           
          ],
        ),
     ),
   );
  }
    


  FlatButton scanQr(String qrResult)  {
    return FlatButton(
            padding: EdgeInsets.all(15.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
              side: BorderSide(color: Colors.blue.withOpacity(0.5), width: 3.0)
            ),
            onPressed: ()async{
              String scaning =  await BarcodeScanner.scan();
               setState(() {
                 qrResult=scaning;
               }); 
            },
            child: Text('Escanear codigo Qr')
          );
  }
}