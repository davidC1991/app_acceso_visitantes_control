import 'dart:io';
import 'package:acceso_residencial/helpers/alertasRapidas.dart';
import 'package:acceso_residencial/main.dart';
import 'package:acceso_residencial/models/historialQrModel.dart';
import 'package:acceso_residencial/provider/getDatosUsurio.dart';
import 'package:acceso_residencial/provider/getHistorialQr.dart';
import 'package:acceso_residencial/provider/navegacion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart';
import 'package:screenshot/screenshot.dart';
import 'package:acceso_residencial/widgets/custom_input.dart';
import 'package:acceso_residencial/provider/validacion.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:uuid/uuid.dart';


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
  String _range = '';
  bool showCalender= false;
  int cont=0;
  var uuid = Uuid();
  

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
     
     if (args.value is PickerDateRange) {
        cont++;
        _range = DateFormat('yyyy/MM/dd').format(args.value.startDate).toString() + ' - ' +
                 DateFormat('yyyy/MM/dd').format(args.value.endDate ?? args.value.startDate).toString();
         print(_range);    
         diasValidezVisitante.text=_range;
         
         if(cont==2){
           cont=0;
           //showCalender=false;
         }

         setState(() { });      
     }
  }
 
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    final datosUsuarioAll = Provider.of<GetDatosUsuario>(context, listen: false);
    final historialQr = Provider.of<GetHistorialQr>(context);
 
    if (!datosUsuarioAll.datosYaObtenidos){
        validarUsuario(datosUsuarioAll);
        
    }
    final navegacionModel = Provider.of<NavegacionModel>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: titulo(navegacionModel.tituloPantalla,15.0, Colors.blue[600],EdgeInsets.only(left: 0,bottom: 15,right: 10,top: 20)),
        actions: [
          GestureDetector(
             onTap: ()async{
              codigoQrImage=null;
              Navigator.pushReplacementNamed(context, 'login');
            },
            child: Container(
              
              alignment: Alignment.center,
              width: size.width*0.2,
              child: Text('Cerrar',style: TextStyle(color: Colors.grey[600], fontSize: 15, fontWeight: FontWeight.bold))),
          ), 
       ],
      ),
      body: PageView(
        controller: navegacionModel.pageController,
        physics: BouncingScrollPhysics(),
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                titulo('Escriba los nombres y apellidos de su visita *',17.0,Colors.black45,EdgeInsets.only(left: 20,bottom: 15,right: 10,top: 20)),
                CustomInput(icon:Icons.person,placeholder:'Nombres', textController:nombreVisitante,keyboardType:TextInputType.text,isPassword: false), 
                CustomInput(icon:Icons.person,placeholder:'Apellidos', textController:apellidosVisitante,keyboardType:TextInputType.text,isPassword: false), 
                titulo('¿Cuantas personas asistiran? *',17.0,Colors.black45,EdgeInsets.only(left: 20,bottom: 15,right: 10,top: 20)),
                CustomInput(icon:Icons.people,placeholder:'Numero personas', textController:cantidadPersonasVisitante,keyboardType:TextInputType.number,isPassword: false), 
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    titulo('Ingrese el rango de fechas de validez *',17.0,Colors.black45,EdgeInsets.only(left: 20,bottom: 15,right: 10,top: 20)),
                    IconButton(
                       icon: Icon(Icons.calendar_today,color: Colors.blue[300],),
                       onPressed: (){
                         showCalender=true;
                         setState(() { });
                       }),
                    
                  ],
                ),
                CustomInput(icon:Icons.calendar_view_day,placeholder:'Dias en los que el codigo sera valido', textController:diasValidezVisitante,keyboardType:TextInputType.number,isPassword: false), 
                showCalender?Container(
                  child: SfDateRangePicker(
                    selectionMode: DateRangePickerSelectionMode.range,  
                    onSelectionChanged: _onSelectionChanged,
                  ),
                ):Container(),
                showCalender?boton_calendar():Container(),
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
          historialQr.loading=='cargado'?ListView.builder(
            shrinkWrap: true,
            itemCount: historialQr.listQr.length,
            itemBuilder: (context,i){
               return itemHistorial(historialQr.listQr[i],i);
            })
            :historialQr.loading=='cargando'?Center(child: CircularProgressIndicator())
            :Center(child: Text('No hay datos para mostrar')) 
        ],
              ),
              bottomNavigationBar: Navegacion(),
            );
          }
        // ignore: non_constant_identifier_names
        Widget boton_calendar(){
          return FlatButton(
            padding: EdgeInsets.all(10.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: BorderSide(color: Colors.blue.withOpacity(0.5), width: 3.0)
                    ),
            onPressed: () { 
                showCalender=false;
                setState(() {});
              },
            child: Text('Escoger fecha',style: TextStyle(color: Colors.grey[600], fontSize: 15, fontWeight: FontWeight.w400)) ,
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
          await datosUsuarioAll.conseguirDatosUsuario('105951231609486716903');
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
                       padding: const EdgeInsets.all(3.0),
                       child: FlatButton(
                              padding: EdgeInsets.all(10.0),
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
                
                                              guardarPermisoGenerado(datosUsuarioAll);                
                                              setState(() {});  
                                               }else{
                                                 mensajePantalla('LLene todos los campos obligatorios');
                                               }
                                                 
                               
                                             },
                                             child: Text('Generar codigo Qr',style: TextStyle(color: Colors.grey[600], fontSize: 15, fontWeight: FontWeight.w400))
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
                                   dataResidente['nombre']=datosUsuarioAll.datosCompletosUsuario.nombreRegistro;
                                   dataResidente['apellidos']=datosUsuarioAll.datosCompletosUsuario.apellidosRegistro;
                                   dataResidente['celular']=datosUsuarioAll.datosCompletosUsuario.celularRegistro;
                                   //dataResidente['codigo']=datosUsuarioAll.datosCompletosUsuario.codigo;
                                   dataResidente['correo']=datosUsuarioAll.datosCompletosUsuario.correo;
                                   dataResidente['correoRegistro']=datosUsuarioAll.datosCompletosUsuario.correoRegistro;
                                   dataResidente['fotoUrl']=datosUsuarioAll.datosCompletosUsuario.fotoUrl;
                                   dataResidente['idCorreo']=datosUsuarioAll.datosCompletosUsuario.idCorreo;
                                   dataResidente['tipoUsuario']=datosUsuarioAll.datosCompletosUsuario.role;
                                   dataResidente['apartamento']=datosUsuarioAll.datosCompletosUsuario.apartamento;
                                   dataResidente['torre']=datosUsuarioAll.datosCompletosUsuario.torre;
                               
                                   //print('datos del residente: $dataResidente');
                                   print('::::::::::::::::::::::ENCRIPTNDO MENSAJE:::::::::::::::::::::');
                                   encriptar('visitante*nombreV|${dataVisitante['nombres']}*apellidosV|${dataVisitante['apellidos']}*numeroPersonas|${dataVisitante['numeroPersonas']}*diasValidez|${dataVisitante['diasValidez']}*zonaRecreacional|${dataVisitante['zonaRecreacional']}*residente*nombreR|${dataResidente['nombre']}*apellidosR|${dataResidente['apellidos']}*celular|${dataResidente['celular']}*fotoUrl|${dataResidente['fotoUrl']}*apartamento|${dataResidente['apartamento']}*torre|${dataResidente['torre']}');
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
                               
                                 void guardarPermisoGenerado(final datosUsuarioAll)async {
                                   
                                   historialQr.doc(datosUsuarioAll.datosCompletosUsuario.tokenPrincipal).collection(datosUsuarioAll.datosCompletosUsuario.idCorreo).add(
                                     {
                                       'nombreVisitante': dataVisitante['nombres'],
                                       'apellidosVisitante':dataVisitante['apellidos'],
                                       'nombreAcceso':dataResidente['nombre'],
                                       'apellidoAcceso':dataResidente['apellidos'],
                                       'idAcceso':dataResidente['idCorreo'],
                                       'fecha':DateTime.now()
                
                                     }
                                   );
                                   DocumentSnapshot datos= await historialQr.doc(datosUsuarioAll.datosCompletosUsuario.tokenPrincipal).get();
                                   print('::::::::::::::::::::::::::');
                                   print(datos.data());  
                                   if (datos.data()==null){
                                      historialQr.doc(datosUsuarioAll.datosCompletosUsuario.tokenPrincipal).set(
                                     {
                                       'ids': [datosUsuarioAll.datosCompletosUsuario.idCorreo],
                                     }
                                    );
                                   }else{
                                     print('No esta vacio! Actualizar');
                                     List<String> listId=[];
                                     
                                     datos.data().forEach((key, value) { 
                                        value.contains(datosUsuarioAll.datosCompletosUsuario.idCorreo)?print(''):listId.add(datosUsuarioAll.datosCompletosUsuario.idCorreo);
                                        value.forEach((element){
                                        //print(element);
                                        listId.add(element);
                                       });
                                     });
                                     print(listId);

                                      historialQr.doc(datosUsuarioAll.datosCompletosUsuario.tokenPrincipal).update(
                                     {
                                       'ids': listId,
                                     }
                                    );
                                   }       
                                 }

                                      
                                  
                
                  Widget itemHistorial(HistorialQr listQr, int i) {
                    return Column(
                      children: [
                        ListTile(
                          title: Text('Usuario: '+listQr.nombreAcceso + ' ' + listQr.apellidosAcceso),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Visitante'),
                              Text(listQr.nombreVisitante + ' ' + listQr.apellidosVisitantes),
                              Text(listQr.fecha.toDate().toString())
                            ],
                          ),
                          //trailing: 
                        ),
                        Divider()
                      ],
                    );
                  }

}

class Navegacion extends StatelessWidget {
 

  @override
  Widget build(BuildContext context) {
    final datosUsuarioAll = Provider.of<GetDatosUsuario>(context, listen: false);
    final navegacionModel = Provider.of<NavegacionModel>(context);
    final historialQr = Provider.of<GetHistorialQr>(context);
    
    return BottomNavigationBar(
      currentIndex: navegacionModel.paginaActual,
      onTap: (i)async{
        navegacionModel.paginaActual=i;
        
        if (i==1){
           navegacionModel.setTituloPantalla('Historial de reservas');
           historialQr.setLoading='cargando';
           historialQr.getHistorialQrUsuario(datosUsuarioAll.datosCompletosUsuario.tokenPrincipal,datosUsuarioAll.datosCompletosUsuario.idCorreo);
        }else{
          navegacionModel.setTituloPantalla('Genera permiso a tu visita');
        }
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.people_outline),title: Text('Ajustes')),
        BottomNavigationBarItem(icon: Icon(Icons.public),title: Text('Generar'))
    ]);
  }
}
    
   
    
      
      
      
        
        
      
    

        
    
         
    
              
               
    
    
  
       

  