import 'dart:io';
import 'package:acceso_residencial/provider/getDatosUsurio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart';
import 'package:screenshot/screenshot.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:acceso_residencial/helpers/alertasRapidas.dart';
import 'package:acceso_residencial/widgets/custom_input.dart';
import 'package:acceso_residencial/pages/login.dart';
import 'package:acceso_residencial/provider/validacion.dart';
import 'package:encrypt/encrypt.dart' as encrypt;


// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  // ignore: avoid_init_to_null
  QrImage codigoQrImage=null;
  TextEditingController nombreVisitante= TextEditingController();
  TextEditingController apellidosVisitante= TextEditingController();
  TextEditingController cantidadPersonasVisitante= TextEditingController();
  TextEditingController diasValidezVisitante= TextEditingController();
  TextEditingController zonaRecreacionalVisitante= TextEditingController();
  Map<String, String> dataVisitante=new Map();
  ScreenshotController screenshotController = ScreenshotController();
  List<String> imagePaths = [];
  String llave='VENECIA_1_R4PxiU3h8YoIRqVowBXmZc';
  String codigoSeguridadQR = null;
  Map<String,dynamic> dataResidente= Map();

   logoutUsser(){
    gSignIn.signOut();
  }
 
  @override
  Widget build(BuildContext context) {
    final validacion= Provider.of<Validacion>(context, listen: false);
    final datosUsuarioAll = Provider.of<GetDatosUsuario>(context, listen: false);
    if (!datosUsuarioAll.datosYaObtenidos){
        validarUsuario(datosUsuarioAll);
    }
    print(validacion.urlPhoto);
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: titulo('Genera permiso a tu visita',15.0, Colors.blue[600],EdgeInsets.only(left: 0,bottom: 15,right: 10,top: 20)),
        actions: [
          GestureDetector(
             onTap: ()async{
              codigoQrImage=null;
              await logoutUsser();
              Navigator.pushReplacementNamed(context, 'login');
              
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
               radius: 20.0,
               backgroundImage: CachedNetworkImageProvider(validacion.urlPhoto),
              ),
            ),
          ), 
         /*  GestureDetector(
            onTap: ()async{
              codigoQrImage=null;
              await logoutUsser();
              Navigator.pushReplacementNamed(context, 'login');f
              //limpiar();  
              /* setState(() {
                
              }); */
            },
            child: titulo('Limpiar',15.0, Colors.red,EdgeInsets.only(left: 20,bottom: 15,right: 10,top: 20))), */
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            titulo('Escriba los nombres y apellidos de su visita',17.0,Colors.black45,EdgeInsets.only(left: 20,bottom: 15,right: 10,top: 20)),
            CustomInput(icon:Icons.person,placeholder:'Nombres *', textController:nombreVisitante,keyboardType:TextInputType.text,isPassword: false), 
            CustomInput(icon:Icons.person,placeholder:'Apellidos *', textController:apellidosVisitante,keyboardType:TextInputType.text,isPassword: false), 
            titulo('¿Cuantas personas asistiran?',17.0,Colors.black45,EdgeInsets.only(left: 20,bottom: 15,right: 10,top: 20)),
            CustomInput(icon:Icons.people,placeholder:'Numero personas *', textController:cantidadPersonasVisitante,keyboardType:TextInputType.number,isPassword: false), 
            titulo('Digite el tiempo de validez del codigo de acceso',17.0,Colors.black45,EdgeInsets.only(left: 20,bottom: 15,right: 10,top: 20)),
            CustomInput(icon:Icons.calendar_view_day,placeholder:'Dias apartir de la creación *', textController:diasValidezVisitante,keyboardType:TextInputType.number,isPassword: false), 
            titulo('Opcional',17.0,Colors.black45,EdgeInsets.only(left: 20,bottom: 15,right: 10,top: 20)),
            CustomInput(icon:Icons.access_alarm,placeholder:'Zona recreacional del conjunto', textController:zonaRecreacionalVisitante,keyboardType:TextInputType.text,isPassword: false), 
            codigoQrImage!=null?Center(
              child: Column(
                children: [
                  Screenshot(
                    controller:screenshotController,
                    child: Container(
                      color: Colors.white,
                      child: codigoQrImage)
                  ),
                  buttonShare(context)
                ],
              )):
              Container(),
              botonGenerarQr(datosUsuarioAll),
             
          ],
        ),
      ),
   );
  }

  Widget buttonShare(BuildContext context)  {
    return IconButton(
                  icon: Icon(Icons.share),
                  onPressed: ()async{
                   String path;
                   path=await capturarQr();
                   
                   imagePaths.clear();
                   imagePaths.add(path);
                   print(imagePaths);
                  // final RenderBox box = context.findRenderObject();
                  
                   Share.shareFiles(
                    imagePaths,
                    text: 'Al momento de entrar al conjunto residencial muestre este condigo al portero, el mismo tiene una duración de ${diasValidezVisitante.text} dias!',
                    //subject: '-------',
                    //sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size
                    );  
                  setState(() {
                    
                  });
                  }
                );
  }

   validarUsuario(final datosUsuarioAll)async{
    await datosUsuarioAll.conseguirDatosUsuario('104675013366507154389');
    print('${datosUsuarioAll.datosCompletosUsuario.nombre}');
    //print('${validacion.isUsser}');
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

  Widget botonGenerarQr(final datosUsuarioAll) {

     return Padding(
       padding: const EdgeInsets.all(8.0),
       child: FlatButton(
              padding: EdgeInsets.all(15.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                side: BorderSide(color: Colors.blue.withOpacity(0.5), width: 3.0)
              ),
              onPressed: (){
              bool isOk= organizarInformacion(datosUsuarioAll); 
              print('Mensaje encriptado: $codigoSeguridadQR');
             
              if(isOk){
               codigoQrImage= QrImage(
                                 data: codigoSeguridadQR.toString(),
                                 size: 250.0,
                                 gapless: true,
                                 errorCorrectionLevel: QrErrorCorrectLevel.Q,
                               ); 
               setState(() {});  
                }else{
                  mensajePantalla('LLene todos los campos obligatorios');
                }
                  

              },
              child: Text('Generar codigo Qr')
            ),
     );
  }

 bool organizarInformacion(final datosUsuarioAll){
   //CODIGO PARA ESTABLECER Y ENCRIPTAR EL CODIGO DEL CONJUNTO RESIDENCIAL
   
   //encriptar('aprobado');
   //DECODIFICAR('LLAVE QUE TIENE LA APP GUARDADA','CODIGO LEIDO DE QR')
   //decodificar(llave,codigoSeguridadQR);  
   bool isValid=true;
    //:::::::::::DATOS DEL VISITANTE::::::::::::::::::::::::::::::::::::::
    dataVisitante['nombres']          =nombreVisitante.text;
    dataVisitante['apellidos']        =apellidosVisitante.text;
    dataVisitante['numeroPersonas']   =cantidadPersonasVisitante.text;
    dataVisitante['diasValidez']      =diasValidezVisitante.text;
    dataVisitante['zonaRecreacional'] =zonaRecreacionalVisitante.text;
    //::::::::::::DATOS DEL RESIDENTE:::::::::::::::::::::::::::::::::::::
    dataResidente['nombre']=datosUsuarioAll.datosCompletosUsuario.nombre;
    dataResidente['apellidos']=datosUsuarioAll.datosCompletosUsuario.apellidos;
    dataResidente['celular']=datosUsuarioAll.datosCompletosUsuario.celular;
    dataResidente['codigo']=datosUsuarioAll.datosCompletosUsuario.codigo;
    dataResidente['correo']=datosUsuarioAll.datosCompletosUsuario.correo;
    dataResidente['correoRegistro']=datosUsuarioAll.datosCompletosUsuario.correoRegistro;
    dataResidente['displayName']=datosUsuarioAll.datosCompletosUsuario.displayName;
    dataResidente['fotoUrl']=datosUsuarioAll.datosCompletosUsuario.fotoUrl;
    dataResidente['idCorreo']=datosUsuarioAll.datosCompletosUsuario.idCorreo;
    dataResidente['tipoUsuario']=datosUsuarioAll.datosCompletosUsuario.role;
    dataResidente['apartamento']=datosUsuarioAll.datosCompletosUsuario.apartamento;
    dataResidente['torre']=datosUsuarioAll.datosCompletosUsuario.torre;

    //print('datos del residente: $dataResidente');
    print('::::::::::::::::::::::ENCRIPTNDO MENSAJE:::::::::::::::::::::');
    encriptar('visitante-nombre:${dataVisitante['nombres']}-apellidos:${dataVisitante['apellidos']}-numeroPersonas:${dataVisitante['numeroPersonas']}-diasValidez:${dataVisitante['diasValidez']}-zonaRecreacional:${dataVisitante['zonaRecreacional']}-residente-nombre: ${dataResidente['nombre']}-apellidos: ${dataResidente['apellidos']}-celular: ${dataResidente['celular']}-fotoUrl: ${dataResidente['fotoUrl']}-apartamento: ${dataResidente['apartamento']}-torre: ${dataResidente['torre']}');
    //print(dataVisitante);
    dataVisitante.forEach((key, value) { 
      if( value.isEmpty&&!key.contains('zonaRecreacional')){
       isValid=false;
      }
      
    });
    return isValid;
  }
  limpiar(){
    nombreVisitante.clear();
    apellidosVisitante.clear();
    cantidadPersonasVisitante.clear();
    diasValidezVisitante.clear();
    zonaRecreacionalVisitante.clear();
    codigoQrImage=null;
  }

  Future<String>capturarQr( )async{
  
   String path='';
   await screenshotController.capture().then((File image) async {
          //print("Capture Done");
         
          //  setState(() {
          //    _imageFile = image;
          //  });
           // final result = await ImageGallerySaver.save(image.readAsBytesSync()); // Save image to gallery,  Needs plugin  https://pub.dev/packages/image_gallery_saver
            print(image.path);
              path=image.path;
               
            //print("File Saved to Gallery");
          }).catchError((onError) {
            print(onError);
          });
      return path;    
 }

 decodificar(String llave, String resQr){
   final rawKey=llave;
   final key1 = encrypt.Key.fromUtf8(rawKey);
   final iv1 = encrypt.IV.fromLength(16);
   final encrypter1 = encrypt.Encrypter(encrypt.AES(key1));
   
   try {
     final decrypted1 = encrypter1.decrypt64(resQr, iv: iv1);
     print('Mensaje desencriptado: $decrypted1');
   } catch (e) {
     print('llave incorrecta');
   }
   
 }

 encriptar(String bandera){
   //CODIGO PARA ESTABLECER Y ENCRIPTAR EL CODIGO DEL CONJUNTO RESIDENCIAL
   
   final plainText = bandera;
   final key = encrypt.Key.fromUtf8(llave);
   final iv = encrypt.IV.fromLength(16);
   final encrypter = encrypt.Encrypter(encrypt.AES(key));

   final encrypted = encrypter.encrypt(plainText, iv: iv);
   final decrypted = encrypter.decrypt(encrypted, iv: iv);

   print('mensaje a encriptar: $decrypted'); // Lorem ipsum dolor sit amet, consectetur adipiscing elit
   print('mensaje encriptado: ${encrypted.base64}');
   codigoSeguridadQR=encrypted.base64;
 }

}
    
   
    
      
      
      
        
        
      
    

        
    
         
    
              
               
    
    
  
       

  