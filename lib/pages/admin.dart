import 'package:acceso_residencial/helpers/alertasRapidas.dart';
import 'package:acceso_residencial/helpers/dropDown.dart';
import 'package:acceso_residencial/helpers/validarCamposVacios.dart';
import 'package:acceso_residencial/main.dart';
import 'package:acceso_residencial/provider/crearCodigo.dart';
import 'package:acceso_residencial/widgets/custom_input.dart';
import 'package:acceso_residencial/widgets/texto.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:acceso_residencial/services/Envio_msm.dart';


class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  // ignore: non_constant_identifier_names
  EnviarMensaje envi_msm= EnviarMensaje();
  Map<String,dynamic> datos= Map();
  TextEditingController nombreController= TextEditingController();
  TextEditingController apellidosController= TextEditingController();
  TextEditingController torreController= TextEditingController();
  TextEditingController apartamentoController= TextEditingController();
  TextEditingController correoController= TextEditingController();
  TextEditingController celularController= TextEditingController();
  TextEditingController empresaController= TextEditingController();
  String? actor='';
  // ignore: non_constant_identifier_names
  bool switch_=false;
  String codigo='';

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    final createCode= Provider.of<Crearcodigo>(context);
    actor=createCode.actor;
    
    //if(createCode.isCreatedCode){
       
       
    //}
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: titulo('Crea codigos de acceso',15.0, Colors.blue[600],EdgeInsets.only(left: 0,bottom: 15,right: 10,top: 20)),
        actions: [
        
         GestureDetector(
             onTap: ()async{
             
           
              Navigator.pushReplacementNamed(context, 'login');
              
            },
            child: Container(
              
              alignment: Alignment.center,
              width: size.width*0.2,
              child: Text('Cerrar',style: TextStyle(color: Colors.grey[600], fontSize: 15, fontWeight: FontWeight.bold))),
          ), 
           
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: size.height*0.02),
            
            CustomInput(icon:Icons.person,placeholder:'Nombre', textController:nombreController,keyboardType:TextInputType.text,isPassword: false), 
            CustomInput(icon:Icons.person,placeholder:'Apellidos', textController:apellidosController,keyboardType:TextInputType.text,isPassword: false), 
           
            actor!.contains('Portero')
            ?CustomInput(icon:Icons.compare,placeholder:'Empresa', textController:empresaController,keyboardType:TextInputType.text,isPassword: false)
            :actor!.contains('Residente')?
            CustomInput(icon:Icons.adb,placeholder:'Torre', textController:torreController,keyboardType:TextInputType.number,isPassword: false)
            :Container(), 
           
             actor!.contains('Residente')
             ?CustomInput(icon:Icons.aspect_ratio,placeholder:'Apartamento', textController:apartamentoController,keyboardType:TextInputType.text,isPassword: false)
             :Container(), 

            CustomInput(icon:Icons.email,placeholder:'Correo', textController:correoController,keyboardType:TextInputType.text,isPassword: false), 
            CustomInput(icon:Icons.phone,placeholder:'Celular', textController:celularController,keyboardType:TextInputType.number,isPassword: false), 
            SizedBox(height: size.height*0.02),
            Titulo(texto:'Escoja el tipo de usuario', size:15,color: Colors.grey,padding: EdgeInsets.only(left:45),),
            SizedBox(height: size.height*0.02),
            DropDownWidget(),
            SizedBox(height: size.height*0.02),
            createCode.isCreatedCode?Container(
              alignment: Alignment.center,
              height: size.height*0.05,
              width: size.width*1,
              color: Colors.grey[350],
              child: Text('xxxxx'+codigo.substring(5,23)),
            ):Container(),

              createCode.isCreatedCode?Container(
               alignment: Alignment.center,
               width: size.width*1,
               child: Column(
                 children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                     children: [
                       Titulo(texto:'¿Enviar codigo por msm de texto?', size:15,color: Colors.grey,padding: EdgeInsets.only(left:5),),
                       Switch(
                         value: this.switch_,
                         onChanged: (bool value){
                           setState(() {
                             this.switch_=value;
                           });
                         }),
                     ],
                   ),
                   boton('Enviar',context, size), 
                   boton('Limpiar',context, size)      
                 ],
               ),
              )
              :Container(
              alignment: Alignment.center,
              //height: size.height*0.05,
              width: size.width*1,
              child: boton('Crear codigo',context, size))
              
            //Boton(label: 'Crear codigo') 
          ],
     ),
      ),
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

   guardarUsuario(final createCode)async{
     if(actor=='Portero'){
         codigos.doc(codigo).set({
           'nombre'      :nombreController.text,
           'apellidos'   :apellidosController.text,
           'celular'     :celularController.text,
           'correo'      :correoController.text,
           'codigo'      :codigo,
           'tipoUsuario' :actor,
           'empresa'     :empresaController.text
        
       }); 
      }else if(actor=='Residente'){
         codigos.doc(codigo).set({
           'nombre'      :nombreController.text,
           'apellidos'   :apellidosController.text,
           'celular'     :celularController.text,
           'torre'       :torreController.text,
           'apartamento' :apartamentoController.text,
           'correo'      :correoController.text,
           'codigo'      :codigo,
           'tipoUsuario' :actor 
        
       }); 
     }else if(actor=='administrador'){
         codigos.doc(codigo).set({
           'nombre'      :nombreController.text,
           'apellidos'   :apellidosController.text,
           'celular'     :celularController.text,
           'correo'      :correoController.text,
           'codigo'      :codigo,
           'tipoUsuario' :actor 
        
       }); 
     
      }
   }

   Widget boton(String texto, BuildContext context,Size size) {
     final createCode= Provider.of<Crearcodigo>(context);
    
     return Padding(
       padding: const EdgeInsets.all(8.0),
       child: Container(
         width: size.width*0.7,
         child: FlatButton(
                padding: EdgeInsets.all(15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(color: Colors.blue.withOpacity(0.5), width: 3.0)
                ),
                
                onPressed: ()async {
                   if(texto=='Crear codigo'){
                       datos['nombre']     =nombreController.text;
                       datos['apellidos']  =apellidosController.text;
                       datos['celular']    =celularController.text;
                       // ignore: unnecessary_statements
                       actor=='Residente'?datos['torre']=torreController.text:(){};
                       // ignore: unnecessary_statements
                       actor=='Residente'?datos['apartamento']=apartamentoController.text:(){};
                       datos['correo']     =correoController.text;
                       // ignore: unnecessary_statements
                       actor=='Portero'?datos['empresa']=empresaController.text:(){};
                       //datos['codigo']     =nombreController.text;
                       actor= createCode.actor;
                       print('------>');
                       print(actor);
                       if(!validarCamposVacios(datos)){
                           mensajePantalla('LLene los campos vacios');
                         }else{
                            String nombre=datos['nombres'].toString()+datos['apellidos'].toString();
                            codigo= Uuid().v5(Uuid.NAMESPACE_URL,nombre).substring(0,23);
                            createCode.createCode(true);
                            mensajePantalla('Codigo generado exitosamente!');
                         }
                   }
                  if(texto=='Enviar'){
                     if(switch_){ 
                     await envi_msm.envioMsm(datos['celular'].trim(),
                               'Cordial saludo '+ datos['apellidos'] +',el admin de su conjunto'+
                               'lo invita a registrarse en la app de acceso con el siguiente codigo '+codigo);
                     guardarUsuario(createCode);          
                     mensajePantalla('mensaje enviado exitosamente!');
                     createCode.codeEnd(false);
                     nombreController.clear();
                     apellidosController.clear();
                     celularController.clear();
                     torreController.clear();
                     apartamentoController.clear();
                     correoController.clear();
                     empresaController.clear();
                     codigo='';
                     }else{
                       mensajePantalla('Active la opcion de envío de msm!');
                     }
                    }
                   if(texto=='Limpiar'){
                      
                         nombreController.clear();
                         apellidosController.clear();
                         celularController.clear();
                         torreController.clear();
                         apartamentoController.clear();
                         correoController.clear();
                         empresaController.clear();
                         codigo='';
                         createCode.codeEnd(false);
                     }

                   setState(() { });
                },
                child: Text(texto)
              ),
       ),
          );
         }     
}
        
        
        