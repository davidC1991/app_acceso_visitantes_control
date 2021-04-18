
import 'package:acceso_residencial/provider/validacion.dart';
import 'package:acceso_residencial/widgets/texto.dart';

import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:provider/provider.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class ScanPage extends StatefulWidget {

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String qrResult='No hay resultados aun!';
  bool isValidQR=false;
  String llave='VENECIA_1_R4PxiU3h8YoIRqVowBXmZc';
  //String codigoSeguridadQR = null;
  Map<String,String> mapCard= Map();
  
  @override
  Widget build(BuildContext context) {
    final alto= MediaQuery.of(context).size.height;
    Size size=MediaQuery.of(context).size;
    final validacion= Provider.of<Validacion>(context, listen: false);
    return Scaffold(
       appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: Titulo(texto:'Verificar visitantes',size:15.0, color:Colors.blue[600],padding:EdgeInsets.only(left: 0,bottom: 15,right: 10,top: 20)),
        actions: [
          GestureDetector(
            child: Container(
              
              alignment: Alignment.center,
              width: size.width*0.2,
              child: Text('Cerrar',style: TextStyle(color: Colors.grey[600], fontSize: 15, fontWeight: FontWeight.bold))),
             onTap: ()async{
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
               
                SizedBox(height: alto*0.02),
                Titulo(texto:'PROPIETARIO',size:20.0, color:Colors.black45,padding:EdgeInsets.only(left: 10,bottom: 0,right: 10,top: 0)),
                SizedBox(height: alto*0.015),
                container(size,'Nombre:',true),
                container(size,mapCard['nombreR']+' '+mapCard['apellidosR'],false),
                //SizedBox(height: alto*0.015),
                container(size,'Torre:',true),
                container(size,mapCard['apartamento'],false),
                //SizedBox(height: alto*0.015),
                container(size,'Apartamento:',true),
                container(size,mapCard['torre'],false),
                //SizedBox(height: alto*0.015),
                container(size,'Celular:',true),
                container(size,mapCard['celular'],false),   
                 SizedBox(height: alto*0.05),
                Titulo(texto:'VISITANTE',size:20.0, color:Colors.black45,padding:EdgeInsets.only(left: 10,bottom: 0,right: 10,top: 0)),
                SizedBox(height: alto*0.015),
                container(size,'Nombre:',true),
                container(size,mapCard['nombreV']+' '+mapCard['apellidosV'],false),
                //SizedBox(height: alto*0.015),
                container(size,'Numero de personas:',true),
                container(size,mapCard['numeroPersonas'],false),
                //SizedBox(height: alto*0.015),
                container(size,'Fecha de validez:',true),
                container(size,mapCard['diasValidez'],false),
                //SizedBox(height: alto*0.015),
                container(size,'Zona recreacional:',true),
                container(size,mapCard['zonaRecreacional'],false),   
                //proyectoCard(size,context,'propietario'),
                //proyectoCard(size,context,'visitante')
              ],
            ):Column(
              
              children: [
                SizedBox(height: alto*0.15),
                imagenQr(alto),
                Center(child: Titulo(texto:'Veririfique el codigo QR del visitante!',size:20.0, color:Colors.black87,padding:EdgeInsets.only(left: 0,bottom: 15,right: 10,top: 20)))
              ],
            ),
            isValidQR?SizedBox(height: alto*0.04):Container(),
            isValidQR?scanQr(false,'Escanear otro codigo',size):scanQr(true,'Escanear codigo QR',size)
          ],
        ),
      ),
   );
  }
   Widget titulo(String texto, double size, Color color, EdgeInsetsGeometry padding) { 
    return Padding(
      padding: padding,
      child: Text(
        texto,
        style: TextStyle(color: color, fontSize: size, fontWeight: FontWeight.w300),  
      ),
    );
    }

   mostrarAdvertencia(String texto, Size size){
           
    showDialog(
      barrierColor: Colors.blue.withOpacity(0.2),
      context: context,
      builder: (_)=> SimpleDialog(
                contentPadding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 15),
                titlePadding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
                title: Center(child: titulo('¡ Advertencia !',15.0, Colors.blue[600],EdgeInsets.only(left: 0,bottom: 5,right: 10,top: 20))),
                children: [
                  Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 200,
                        height: 200,
                        child:Image(image:AssetImage('assets/error.png')), 
                      ),
                      titulo(texto,15.0, Colors.black,EdgeInsets.only(left: 10,bottom: 5,right: 10,top: 20))
                    ],
                  ),
                  
                ],
              )
            );  
          }

   Widget imagenQr(double alto){
    
     return  Container(
              height: alto*0.3,
              width: 200,
              child: Image(image:AssetImage('assets/codigo-qr.png')),
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
           
     
  Widget container(Size size, String mensaje, bool isTitulo){
    
    return Container(
              alignment: Alignment.centerLeft,
              height: isTitulo?size.height*0.03:size.height*0.04,
              width: size.width*0.8,
              decoration: BoxDecoration(
                color: isTitulo?Colors.white:Colors.grey[200],
                borderRadius: BorderRadius.circular(8)
              ),
              child: Titulo(texto:mensaje,size:15.0, color:Colors.black87,padding:EdgeInsets.only(left: 10,bottom: 0,right: 10,top: 0)),
            );
  }       
              
            


  Widget scanQr(bool change,String titulo,Size size)  {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FlatButton(
              padding: EdgeInsets.all(10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                side: BorderSide(color: Colors.blue.withOpacity(0.5), width: 3.0)
              ),
              onPressed: ()async{
                if (change){
                String scaning =  await BarcodeScanner.scan();
                 String mensaje_decodificado='';
                 DateTime fechaInicial=null;
                 DateTime fechaFinal=null;
                 DateTime fechaActual=DateTime.now();
                 qrResult=scaning;
                 print(qrResult);
                 mensaje_decodificado=decodificar(llave,qrResult);
                 
                
                 print(mensaje_decodificado.indexOf('visitante-'));
                 print(mensaje_decodificado.split('*'));

                 final list_msm=mensaje_decodificado.split('*');
                 
                 list_msm.forEach((element) {
                   if(element.contains('|')){
                     final list_aux=element.split('|');
                     mapCard[list_aux[0]]=list_aux[1];
                   }
                  
                 });
                
                 String f1=mapCard['diasValidez'].split('-')[0].replaceAll('/', '-').trim();
                 String f2=mapCard['diasValidez'].split('-')[1].replaceAll('/', '-').trim();
                 
                 fechaInicial = DateTime.parse(f1);
                 fechaFinal   = DateTime.parse(f2);
                 print(fechaInicial);
                 print(fechaFinal);
                 print(fechaActual);
                 print(fechaInicial.isBefore(fechaActual));
                 print(fechaFinal.isAfter(fechaActual));
                 
                 if (mensaje_decodificado=='llave incorrecta'){
                   isValidQR=false;
                   }{
                   isValidQR=true;
                  }  

                 if(!fechaInicial.isBefore(fechaActual) && fechaFinal.isAfter(fechaActual)){
                   print('Aun no hay acceso para este codigo!');
                   isValidQR=false;
                   mostrarAdvertencia('El codigo es valido, pero aun no tiene acceso.',size);
                 }else if(fechaFinal.isAfter(fechaActual)){
                   print('codigo aun valido_!');
                   setState(() { }); 
                 }else if(fechaInicial.isAfter(fechaActual) && fechaInicial.isAfter(fechaActual)){
                   print('codigo aun valido__!');
                   setState(() { }); 
                 }else{
                   isValidQR=false;
                   print('codigo QR expirado!');
                   mostrarAdvertencia('Codigo QR expirado!',size);
                 }
                 
                 print('mapCard: $mapCard');
                 
                }else{
                  isValidQR=false;
                  setState(() {
                    
                  });
                }
              },
              child: Text(titulo)
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
        height: size.height*0.25,
        //color: Colors.blue,
        
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Card(
              color:Colors.white,
              elevation: 10.0,
              child: Container(
                width: size.width*0.55,
                height: size.height*0.3,
               
                child:
                 Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    role=='propietario'?Titulo(texto:'PROPIETARIO',size:15.0, color:Colors.black54,padding:EdgeInsets.only(left: 10,bottom: 10,right: 10,top: 10))
                                       :Titulo(texto:'VISITANTE',size:15.0, color:Colors.black54,padding:EdgeInsets.only(left: 10,bottom: 10,right: 10,top: 10)),
                    role=='propietario'?Titulo(texto:'Nombre: ${mapCard['nombreR']}',size:15.0, color:Colors.black38,padding:EdgeInsets.only(left: 10,bottom: 5,right: 10,top: 0))
                                       :Titulo(texto:'Nombre: ${mapCard['nombreV']}',size:15.0, color:Colors.black38,padding:EdgeInsets.only(left: 10,bottom: 5,right: 10,top: 0)),
                    role=='propietario'?Titulo(texto:'Apellidos: ${mapCard['apellidosR']}',size:15.0, color:Colors.black38,padding:EdgeInsets.only(left: 10,bottom: 5,right: 10,top: 0))
                                       :Titulo(texto:'Apellidos: ${mapCard['apellidosV']}',size:15.0, color:Colors.black38,padding:EdgeInsets.only(left: 10,bottom: 5,right: 10,top: 0)),
                    role=='propietario'?Titulo(texto:'Apartamento: ${mapCard['apartamento']}',size:15.0, color:Colors.black38,padding:EdgeInsets.only(left: 10,bottom: 5,right: 10,top: 0))
                                       :Titulo(texto:'numeroPersonas: ${mapCard['numeroPersonas']}',size:15.0, color:Colors.black38,padding:EdgeInsets.only(left: 10,bottom: 5,right: 10,top: 0)),
                    role=='propietario'?Titulo(texto:'Torre: ${mapCard['torre']}',size:15.0, color:Colors.black38,padding:EdgeInsets.only(left: 10,bottom: 5,right: 10,top: 0))
                                       :Titulo(texto:'diasValidez: ${mapCard['diasValidez']}',size:15.0, color:Colors.black38,padding:EdgeInsets.only(left: 10,bottom: 5,right: 10,top: 0)),
                    role=='propietario'?Titulo(texto:'Celular: ${mapCard['celular']}',size:15.0, color:Colors.black38,padding:EdgeInsets.only(left: 10,bottom: 15,right: 10,top: 0))
                                       :Titulo(texto:'zonaRecreacional: ${mapCard['zonaRecreacional']}',size:15.0, color:Colors.black38,padding:EdgeInsets.only(left: 10,bottom: 15,right: 10,top: 0)),
                   
                  ], 
                ),
              ),
            ),
           Card(
              elevation:6.0,
              child: Container(
                width: size.width*0.3,
                height: size.height*0.15,
                child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: CircleAvatar(
                 radius: 10.0,  
                 //backgroundImage:  role=='propietario'?CachedNetworkImageProvider(validacion.urlPhoto):AssetImage('assets/comprobar.png'),
               ),
              ),
             ),
            )
          ],
        ),
      ),
    );
  }
                  
  
  decodificar(String llave, String resQr){
   final rawKey=llave;
   final key1 = encrypt.Key.fromUtf8(rawKey);
   final iv1 = encrypt.IV.fromLength(16);
   final encrypter1 = encrypt.Encrypter(encrypt.AES(key1));
   
   try {
     final decrypted1 = encrypter1.decrypt64(resQr, iv: iv1);
     print('Mensaje desencriptado: $decrypted1');
     return decrypted1;
   } catch (e) {
     print('llave incorrecta');
     return 'llave incorrecta';
   }
   
 }

}