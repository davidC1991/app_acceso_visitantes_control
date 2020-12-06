import 'package:acceso_residencial/pages/login.dart';
import 'package:acceso_residencial/provider/validacion.dart';
import 'package:acceso_residencial/widgets/texto.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:provider/provider.dart';


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
    Size size=MediaQuery.of(context).size;
    return Scaffold(
       appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: Titulo(texto:'Verificar visitantes',size:15.0, color:Colors.blue[600],padding:EdgeInsets.only(left: 0,bottom: 15,right: 10,top: 20)),
        actions: [
          GestureDetector(
            child: Text('cerrar'),
             onTap: ()async{
              await logoutUsser();
              Navigator.pushReplacementNamed(context, 'login');
             }),
           
        ],
      ),
              
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            isValidQR?Column(
              children: [
                SizedBox(height: alto*0.05),
                proyectoCard(size,context,'propietario'),
                proyectoCard(size,context,'visitante')
              ],
            ):Column(
              children: [
                SizedBox(height: alto*0.05),
                imagenQr(alto),
                Center(child: Titulo(texto:'Veririfique el codigo QR del visitante!',size:20.0, color:Colors.black87,padding:EdgeInsets.only(left: 0,bottom: 15,right: 10,top: 20)))
              ],
            ),
            isValidQR?SizedBox(height: alto*0.2):Container(),
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


  Widget proyectoCard(Size size, BuildContext context, String role) {
    final validacion= Provider.of<Validacion>(context, listen: false);
    return Center(
      child: Container(
        margin: EdgeInsets.all(10),
        alignment: Alignment.centerLeft,
        //padding: EdgeInsets.all(10.0),
        width: size.width*0.9,
        height: size.height*0.23,
       // color: Colors.blue,
        
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Card(
              color:Colors.white,
              elevation: 10.0,
              child: Container(
                width: size.width*0.5,
                height: size.height*0.3,
               
                child:
                 Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    role=='propietario'?Titulo(texto:'PROPIETARIO',size:15.0, color:Colors.black45,padding:EdgeInsets.only(left: 10,bottom: 10,right: 10,top: 10))
                                       :Titulo(texto:'VISITANTE',size:15.0, color:Colors.black45,padding:EdgeInsets.only(left: 10,bottom: 10,right: 10,top: 10)),
                    role=='propietario'?Titulo(texto:'Nombre: Jesus Edilberto',size:15.0, color:Colors.black38,padding:EdgeInsets.only(left: 10,bottom: 5,right: 10,top: 0))
                                       :Titulo(texto:'XXXXXXXXXXX',size:15.0, color:Colors.black38,padding:EdgeInsets.only(left: 10,bottom: 5,right: 10,top: 0)),
                    role=='propietario'?Titulo(texto:'Apellidos: Callejas Mesa',size:15.0, color:Colors.black38,padding:EdgeInsets.only(left: 10,bottom: 5,right: 10,top: 0))
                                       :Titulo(texto:'XXXXXXXXXXX',size:15.0, color:Colors.black38,padding:EdgeInsets.only(left: 10,bottom: 5,right: 10,top: 0)),
                    role=='propietario'?Titulo(texto:'Apartamento: 801',size:15.0, color:Colors.black38,padding:EdgeInsets.only(left: 10,bottom: 5,right: 10,top: 0))
                                       :Titulo(texto:'XXXXXXXXXXX',size:15.0, color:Colors.black38,padding:EdgeInsets.only(left: 10,bottom: 5,right: 10,top: 0)),
                    role=='propietario'?Titulo(texto:'Torre: 4',size:15.0, color:Colors.black38,padding:EdgeInsets.only(left: 10,bottom: 5,right: 10,top: 0))
                                       :Titulo(texto:'XXXXXXXXXXX',size:15.0, color:Colors.black38,padding:EdgeInsets.only(left: 10,bottom: 5,right: 10,top: 0)),
                    role=='propietario'?Titulo(texto:'Celular: 3003456789',size:15.0, color:Colors.black38,padding:EdgeInsets.only(left: 10,bottom: 15,right: 10,top: 0))
                                       :Titulo(texto:'XXXXXXXXXXX',size:15.0, color:Colors.black38,padding:EdgeInsets.only(left: 10,bottom: 15,right: 10,top: 0)),
                   
                  ], 
                ),
              ),
            ),
           Card(
              elevation:6.0,
              child: Container(
                width: size.width*0.35,
                height: size.height*0.18,
                child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: CircleAvatar(
                 radius: 15.0,  
                 backgroundImage:  role=='propietario'?CachedNetworkImageProvider(validacion.urlPhoto):AssetImage('assets/comprobar.png'),
               ),
              ),
             ),
            )
          ],
        ),
      ),
    );
  }
                  
  logoutUsser(){
    gSignIn.signOut();
  }

}