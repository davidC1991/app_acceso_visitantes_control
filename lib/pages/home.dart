import 'dart:convert';
import 'dart:io';
import 'package:acceso_residencial/models/domiciliosModel.dart';
import 'package:acceso_residencial/provider/getDomicilios.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';
import 'package:acceso_residencial/helpers/alertasRapidas.dart';
import 'package:acceso_residencial/main.dart';
import 'package:acceso_residencial/models/historialQrModel.dart';
import 'package:acceso_residencial/provider/getDatosUsurio.dart';
import 'package:acceso_residencial/provider/getHistorialQr.dart';
import 'package:acceso_residencial/provider/navegacion.dart';
import 'package:acceso_residencial/widgets/labels.dart';
import 'package:acceso_residencial/widgets/texto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart';
import 'package:screenshot/screenshot.dart';
import 'package:acceso_residencial/widgets/custom_input.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  // ignore: avoid_init_to_null
  QrImage? codigoQrImage=null;
  
  TextEditingController nombreVisitante= TextEditingController();
  TextEditingController apellidosVisitante= TextEditingController();
  TextEditingController cantidadPersonasVisitante= TextEditingController();
  TextEditingController diasValidezVisitante= TextEditingController();
  TextEditingController zonaRecreacionalVisitante= TextEditingController();
  
  Map<String, String> dataVisitante=new Map();
  ScreenshotController screenshotController = ScreenshotController();
  List<String?> imagePaths = [];
  late Uint8List _imageFile;
  String llave='VENECIA_1_R4PxiU3h8YoIRqVowBXmZc';
  // ignore: avoid_init_to_null
  String? codigoSeguridadQR = null;
  Map<String,dynamic> dataResidente= Map();
  String _range = '';
  bool showCalender= false;
  bool flagClean=false;
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
        physics: NeverScrollableScrollPhysics(),
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
                         mostrarCalendario(size);
                         showCalender=true;
                         setState(() { });
                       }),
                    
                  ],
                ),
                CustomInput(icon:Icons.calendar_view_day,placeholder:'Dias en los que el codigo sera valido', textController:diasValidezVisitante,keyboardType:TextInputType.number,isPassword: false), 
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
                  flagClean?next(datosUsuarioAll,size,'Limpiar'):next(datosUsuarioAll,size,'Siguiente'),
                 
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
            :Center(child: Text('No hay datos para mostrar')), 
            AjustesPerfil(),
            DomicilioPage()
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
                FocusScope.of(context).requestFocus(new FocusNode());
                Navigator.pop(context);
                setState(() {});
              },
            child: Text('Escoger fecha',style: TextStyle(color: Colors.grey[600], fontSize: 15, fontWeight: FontWeight.w400)) ,
          );
        }
        Widget buttonShare(BuildContext context)  {
          return IconButton(
                        icon: Icon(Icons.share),
                        onPressed: ()async{
                          String? path;
                            
                          path=await capturarQr();
                          
                          imagePaths.clear();
                          imagePaths.add(path);
                          print('imagePath:$path');
                        // final RenderBox box = context.findRenderObject();
                         
                          Share.shareFiles(
                          [path],
                          text: 'Al momento de entrar al conjunto residencial muestre este condigo al portero, el mismo tiene una duración dentro de las fechas ${diasValidezVisitante.text} .',
                          //subject: '-------',
                          //sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size
                          );

                            
                        setState(() {
                          
                        });
                        }
                      );
        }

        
          mostrarCalendario(Size size){
            showDialog(
              barrierColor: Colors.blue.withOpacity(0.2),
              context: context,
              builder: (_)=> SimpleDialog(
                       contentPadding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 15),
                       titlePadding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10),
                       title: Center(child: titulo('¡ Escoja el intervalo de fechas !',15.0, Colors.blue[600],EdgeInsets.only(left: 0,bottom: 5,right: 10,top: 20))),
                       children: [

                         Container(
                           width: size.width*0.4,
                           height: size.height*0.4,
                           //color: Colors.red,
                           child:   SfDateRangePicker(
                              selectionMode: DateRangePickerSelectionMode.range,  
                              onSelectionChanged: _onSelectionChanged,
                           ),
                         ),
                        boton_calendar()
                       ],
                     )
            );  
          }

          mostrarDatosIngresados(Size size, final datosUsuarioAll){
            bool isOk=organizarInformacion(datosUsuarioAll);
           
            if(isOk){
            showDialog(
              barrierColor: Colors.blue.withOpacity(0.2),
              context: context,
              builder: (_)=> SimpleDialog(
                       contentPadding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 5),
                       titlePadding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
                       title: Center(child: titulo('¡ Verificar datos ingresados !',15.0, Colors.blue[600],EdgeInsets.only(left: 0,bottom: 5,right: 10,top: 20))),
                       children: [
                         Column(
                           mainAxisAlignment: MainAxisAlignment.start,
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                              titulo('Nombre: ${nombreVisitante.text}',17.0,Colors.black45,EdgeInsets.only(left: 20,bottom: 5,right: 10,top: 0)),
                              titulo('Apellidos: ${apellidosVisitante.text}',17.0,Colors.black45,EdgeInsets.only(left: 20,bottom: 5,right: 10,top: 0)),
                              titulo('Cantidad de personas: ${cantidadPersonasVisitante.text}',17.0,Colors.black45,EdgeInsets.only(left: 20,bottom: 5,right: 10,top: 0)),
                              titulo('Intervalo de fechas:',17.0,Colors.black45,EdgeInsets.only(left: 20,bottom: 0,right: 10,top: 0)),
                              titulo('${diasValidezVisitante.text}',17.0,Colors.black45,EdgeInsets.only(left: 20,bottom: 5,right: 10,top: 0)),

                              zonaRecreacionalVisitante.text!=''?titulo('Zona recreacional: ${zonaRecreacionalVisitante.text}',17.0,Colors.black45,EdgeInsets.only(left: 20,bottom: 5,right: 10,top: 0)):Container(),
                           ],
                         ),
                         Padding(
                           padding: const EdgeInsets.only(top:20),
                           child: botonGenerarQr(datosUsuarioAll),
                         )
                          
                        //  Container(
                        //    width: size.width*0.4,
                        //    height: size.height*0.4,
                        //    //color: Colors.red,
                        //    child:  
                        //  ),
                       
                       ],
                     )
            );  }else{
              mensajePantalla('LLene todos los campos obligatorios');
            }
          }
      
          validarUsuario(final datosUsuarioAll)async{
          await datosUsuarioAll.conseguirDatosUsuario('105951231609486716903');
          print('${datosUsuarioAll.datosCompletosUsuario.nombre}');
          //print('${validacion.isUsser}');
        }
                    
                  Widget titulo(String texto, double size, Color? color, EdgeInsetsGeometry padding) { 
                    return Padding(
                      padding: padding,
                      child: Text(
                        texto,
                        style: TextStyle(color: color, fontSize: size, fontWeight: FontWeight.w300),  
                      ),
                    );
                   }
                 Widget next(final datosUsuarioAll,Size size,texto) {
                   return  Padding(
                       padding: const EdgeInsets.all(3.0),
                       child: FlatButton(
                              padding: EdgeInsets.all(10.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                side: BorderSide(color: Colors.blue.withOpacity(0.5), width: 3.0)
                              ),
                              onPressed: (){
                                if (texto=='Siguiente'){
                                  mostrarDatosIngresados(size,datosUsuarioAll);
                                }else{
                                  limpiar();
                                }
                              },
                              child: Text(texto,style: TextStyle(color: Colors.grey[600], fontSize: 15, fontWeight: FontWeight.w400)),
                       )
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
                                              flagClean=true;
                                              FocusScope.of(context).requestFocus(new FocusNode());
                                              Navigator.pop(context);            
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
                                   flagClean=false;
                                   nombreVisitante.clear();
                                   apellidosVisitante.clear();
                                   cantidadPersonasVisitante.clear();
                                   diasValidezVisitante.clear();
                                   zonaRecreacionalVisitante.clear();
                                   codigoQrImage=null;
                                   setState(() {  });
                                 }
                               
                                 Future<String>capturarQr( )async{
                                 
                                  String path_='';
                                  // if(kIsWeb){
                                  //   print('esto es web');
                                  //    await screenshotController.capture().then((Uint8List?  image) async {

                                  //       print(image);
                                  //       // var temp = new Uint8List(image);
                                  //       // var list  = new List.from(image);
                                  //       // final imageEncoded= base64.encode(image); 
                                  //       //final bytes = File(image).readAsBytesSync();
                                  //        String base64Img = await toBase64Image(image);
                                  //       FlutterShareMe().shareToWhatsApp(msg: 'jnnknknk');
                 
                                  //    });
                                  // }
                                  // else{
                                    await screenshotController.capture().then((Uint8List?  image) async {
                                          print('----------------------------');
                                              
                                          String tempPath = (await getTemporaryDirectory()).path;
                                          File file = File('$tempPath/image.png');
                                          await file.writeAsBytes(image!);
                                          path_=file.path;
                                          }).catchError((onError) {
                                            print(onError);
                                          });
                                 // }
                                  return path_;      
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
                                  await historialQr.doc(datosUsuarioAll.datosCompletosUsuario.tokenPrincipal).snapshots().forEach((element) {
                                    
                                    List<String> listId=[];
                                    print(element.data());
                                     if (element.data()==null ){
                                          historialQr.doc(datosUsuarioAll.datosCompletosUsuario.tokenPrincipal).set(
                                        {
                                          'ids': [datosUsuarioAll.datosCompletosUsuario.idCorreo],
                                        }
                                       );
                                     }else{
                                       
                                        element.data()!.forEach((key, value) {
                                           value.contains(datosUsuarioAll.datosCompletosUsuario.idCorreo)?print(''):listId.add(datosUsuarioAll.datosCompletosUsuario.idCorreo);
                                            value.forEach((element){
                                              //print(element);
                                              listId.add(element);
                                            });
                                         });
                                     }
                                       historialQr.doc(datosUsuarioAll.datosCompletosUsuario.tokenPrincipal).update(
                                          {
                                            'ids': listId,
                                          }
                                        );
                                  });
                                   

                                   
                                  //  print('::::::::::::::::::::::::::');
                                  //  final dt=datos.data();
                                  //  print(datos.);
                                  //  var json = jsonEncode(datos.data());
                                  //  final sx= jsonDecode(json);
                                  //  print(sx);
                                  //  print(datosUsuarioAll.datosCompletosUsuario.tokenPrincipal);  
                                  //  print('---------------------------------');
                                  //  if (datos.data()==null ){
                                  //     historialQr.doc(datosUsuarioAll.datosCompletosUsuario.tokenPrincipal).set(
                                  //    {
                                  //      'ids': [datosUsuarioAll.datosCompletosUsuario.idCorreo],
                                  //    }
                                  //   );
                                  //  }else{
                                  //    print('No esta vacio! Actualizar');
                                  //   //  List<String> listId=[];
                                     
                                  //   //  datos.data()!.forEach((key, value) { 
                                  //   //     value.contains(datosUsuarioAll.datosCompletosUsuario.idCorreo)?print(''):listId.add(datosUsuarioAll.datosCompletosUsuario.idCorreo);
                                  //   //     value.forEach((element){
                                  //   //     //print(element);
                                  //   //     listId.add(element);
                                  //   //    });
                                  //   //  });
                                  //   //  print(listId);

                                  //   //   historialQr.doc(datosUsuarioAll.datosCompletosUsuario.tokenPrincipal).update(
                                  //   //  {
                                  //   //    'ids': listId,
                                  //   //  }
                                  //   // );
                                  //  }       
                                }

                                      
                                  
                
                  Widget itemHistorial(HistorialQr listQr, int i) {
                    return Column(
                      children: [
                        ListTile(
                          title: Text('Usuario: '+listQr.nombreAcceso! + ' ' + listQr.apellidosAcceso!),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Visitante'),
                              Text(listQr.nombreVisitante! + ' ' + listQr.apellidosVisitantes!),
                              Text(listQr.fecha!.toDate().toString())
                            ],
                          ),
                          //trailing: 
                        ),
                        Divider()
                      ],
                    );
                  }
                                 
}

class AjustesPerfil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    final datosUsuarioAll = Provider.of<GetDatosUsuario>(context, listen: false);
    final key = new GlobalKey<ScaffoldState>();
    return Scaffold(
      key: key,
      body:Column(
         mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
        children:[
           datoUsuario('Nombres:',datosUsuarioAll.datosCompletosUsuario!.nombreRegistro!+' '+datosUsuarioAll.datosCompletosUsuario!.apellidosRegistro!,false),
           datoUsuario('Correo:',datosUsuarioAll.datosCompletosUsuario!.correoRegistro,false),
           datoUsuario('Celular:',datosUsuarioAll.datosCompletosUsuario!.celularRegistro,false),
           datoUsuario('Apartamento:',datosUsuarioAll.datosCompletosUsuario!.apartamento,false),
           datoUsuario('Torre:',datosUsuarioAll.datosCompletosUsuario!.torre,false),
           datoUsuario('Tipo de Usuario:',datosUsuarioAll.datosCompletosUsuario!.role,false),
           datoUsuario('Usuario principal:',datosUsuarioAll.datosCompletosUsuario!.nombre!+' '+datosUsuarioAll.datosCompletosUsuario!.apellidos!,false),
           datoUsuario('Codigo principal de registro:',datosUsuarioAll.datosCompletosUsuario!.tokenPrincipal,true),
           SizedBox(height: size.height*0.15,),
           InkWell(
             onTap: ()=>Navigator.pushNamed(context, 'politicsAndPrivicy'),//launch('https://reasidentqr.000webhostapp.com'),
             child: Center(child: Text('Politics and privacy',style: TextStyle(color: Colors.blue[600]),)))
        ]
      )
    );
  }

  Widget datoUsuario(String etiqueta,String? datoUsuario,bool flag){
    return ListTile(
      //contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
      visualDensity: VisualDensity(horizontal: 1, vertical: -4),
      
          //contentPadding:  EdgeInsets.symmetric(horizontal: 10), 
          //visualDensity: VisualDensity(vertical:0, horizontal: 0.0),
          title:Titulo(texto:etiqueta,size:17.0,color:Colors.black,padding:EdgeInsets.only(left: 0,bottom: 0,right: 0,top: 0)) ,
          subtitle: Row(
            children: [
              Titulo(texto:datoUsuario,size:15.0,color:Colors.black45,padding:EdgeInsets.only(left: 0,bottom: 0,right: 0,top: 0)),
              //flag?Icon(Icons.contact_phone):Text('')
               flag?IconButton(
                icon: Icon(Icons.content_copy, color: Colors.blue[600]),
                onPressed: (){
                  Clipboard.setData(new ClipboardData(text: datoUsuario));
                  mensajePantalla('¡Codigo copiado al portapapeles!');
                }
              ):Text(''),
            ],
          ),
            
         
        );
       
  }
}

class DomicilioPage extends StatelessWidget {
  
  TextEditingController empresaDomicilio= TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    final datosDomicilio = Provider.of<GetDomicilios>(context);
    final datosUsuarioAll = Provider.of<GetDatosUsuario>(context, listen: false);
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: datosDomicilio.loading=='buscarDatos'?ListView.builder(
      
      shrinkWrap: true,
      itemCount: datosDomicilio.listDomicilios.length,
      itemBuilder: (context,i){
        //print(datosDomicilio.listDomicilios);
         return deliveryHistorial(datosDomicilio.listDomicilios[i],i,datosUsuarioAll,datosDomicilio);
      })
      :datosDomicilio.loading=='cargando'?Center(child: CircularProgressIndicator())
      :Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          imagenDelivery(size),
          Center(child: Text('No hay datos para mostrar')),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:(){
          print('ingresó a domicilio');
          ingresarDatosDomicilio(size,context,datosDomicilio);
          //datosDomicilio.setLoading='cargando';
          
        },
        child: Icon(Icons.add_circle_outline_outlined),
      ),
      
    );
  }

  Widget imagenDelivery(Size size){
    
     return  Container(
              color: Colors.red,
              height: size.height *0.4,
              width: size.width *0.8,
              child: Image(
                fit: BoxFit.cover,
                image:AssetImage('assets/delivery.png')),
                
             );
   } 

    Widget deliveryHistorial(DomicilioDatos listDomicilios, int i, final datosUsuarioAll,final datosDomicilio) {
      return Column(
        children: [
          ListTile(
            title: Text('Domicilio en espera: '+listDomicilios.empresaDomicilio!),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Fecha: '+  listDomicilios.timeStamp!.toDate().toString()),
                
              ],
            ),
            trailing: TextButton(
              onPressed: (){
                print('---');
                print(listDomicilios.idDomicilio);
                domicilios.doc(datosUsuarioAll.datosCompletosUsuario!.tokenPrincipal)
                .collection(datosUsuarioAll.datosCompletosUsuario!.idCorreo as String)
                .doc(listDomicilios.idDomicilio).delete();

                datosDomicilio.setLoading='cargando';
                datosDomicilio.getDomiciliosActivos(datosUsuarioAll.datosCompletosUsuario!.tokenPrincipal as String, datosUsuarioAll.datosCompletosUsuario!.idCorreo as String);
          
              },
              child: Text('Cancelar'),
            ) 
              
          ),
          Divider()
        ],
      );
    }

  Widget titulo(String texto, double size, Color? color, EdgeInsetsGeometry padding) { 
    return Padding(
      padding: padding,
      child: Text(
        texto,
        style: TextStyle(color: color, fontSize: size, fontWeight: FontWeight.w300),  
      ),
    );
   }

   ingresarDatosDomicilio(Size size,BuildContext context, final datosDomicilio){
     final datosUsuarioAll = Provider.of<GetDatosUsuario>(context, listen: false);
    
      showDialog(
        barrierColor: Colors.blue.withOpacity(0.2),
        context: context,
        builder: (_)=> AlertDialog(
                  contentPadding: EdgeInsets.symmetric(horizontal: 5.0,vertical: 5),
                  titlePadding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10),
                  title: Center(child: titulo('¿Deseas recibir un domicilio?',15.0, Colors.blue[600],EdgeInsets.only(left: 0,bottom: 5,right: 10,top: 20))),
                  content: Container(
                              width: size.width*0.4,
                              height: size.height*0.2,
                              //color: Colors.red,
                              child:   Column(
                                children: [
                                  titulo('Ingrese el nombre de la empresa o persona encargada',15.0,Colors.black45,EdgeInsets.only(left: 20,bottom: 15,right: 10,top: 20)),
                                  CustomInput(icon:Icons.person,placeholder:'Domiciliario', textController:empresaDomicilio,keyboardType:TextInputType.text,isPassword: false), 
                                ],
                              )
                            ),
                  actions: [
                    TextButton(
                      onPressed: ()=>Navigator.pop(context),
                       child: Text('Cancelar')
                    ),
                    TextButton(
                      onPressed: (){
                         domicilios.doc(datosUsuarioAll.datosCompletosUsuario!.tokenPrincipal).collection(datosUsuarioAll.datosCompletosUsuario!.idCorreo as String).add(
                            {
                               'torre':datosUsuarioAll.datosCompletosUsuario!.torre,
                               'apto' :datosUsuarioAll.datosCompletosUsuario!.apartamento,
                               'tokenPrincipal':datosUsuarioAll.datosCompletosUsuario!.tokenPrincipal,
                               'idCorreo':datosUsuarioAll.datosCompletosUsuario!.idCorreo,
                               'empresaDomicilio':empresaDomicilio.text,
                               'fecha':DateTime.now()
                            }
                          );
                          empresaDomicilio.clear();
                          datosDomicilio.setLoading='cargando';
                          datosDomicilio.getDomiciliosActivos(datosUsuarioAll.datosCompletosUsuario!.tokenPrincipal as String, datosUsuarioAll.datosCompletosUsuario!.idCorreo as String);
          
                          Navigator.pop(context);
                      },
                       child: Text('Reportar')
                    ),

                  ],          
                )
        );  
    }  
                
                  
}
class Navegacion extends StatelessWidget {
 

  @override
  Widget build(BuildContext context) {
    final datosUsuarioAll = Provider.of<GetDatosUsuario>(context, listen: false);
    final navegacionModel = Provider.of<NavegacionModel>(context);
    final historialQr = Provider.of<GetHistorialQr>(context);
    final datosDomicilio = Provider.of<GetDomicilios>(context, listen: false);
    
    return BottomNavigationBar(
      currentIndex: navegacionModel.paginaActual,
      onTap: (i)async{
        navegacionModel.paginaActual=i;
        print(i);
        if (i==1){
           navegacionModel.setTituloPantalla('Historial de reservas');
           historialQr.setLoading='cargando';
           historialQr.getHistorialQrUsuario((datosUsuarioAll.datosCompletosUsuario!.tokenPrincipal as String),(datosUsuarioAll.datosCompletosUsuario!.idCorreo as String));
           //historialQr.getHistorialQrUsuario('3298c454-17d5-56f4-867a','VD01ZL6seUQGN3obOXKkNrfbQ3z1');
        }else if(i==0){
          navegacionModel.setTituloPantalla('Generar codigo de acceso');
        }else if(i==3){
          //datosDomicilio.
          datosDomicilio.setLoading='cargando';
          datosDomicilio.getDomiciliosActivos(datosUsuarioAll.datosCompletosUsuario!.tokenPrincipal as String, datosUsuarioAll.datosCompletosUsuario!.idCorreo as String);
          
          navegacionModel.setTituloPantalla('Generar codigo para domicilio');
        }else{
          navegacionModel.setTituloPantalla('Datos de perfil');
        }

        
      },
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels:true ,
      selectedLabelStyle: TextStyle(color: Colors.grey),
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.gamepad),label: 'Generar'),
        BottomNavigationBarItem(icon: Icon(Icons.history),label: 'Historial'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline),label: 'Perfil'),
        BottomNavigationBarItem(icon: Icon(Icons.delivery_dining_rounded),label: 'Domicilios')
    ]);
  }
}
    
   
    
      
      
      
        
        
      
    

        
    
         
    
              
               
    
    
  
       

  