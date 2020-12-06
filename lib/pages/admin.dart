import 'package:acceso_residencial/helpers/alertasRapidas.dart';
import 'package:acceso_residencial/helpers/dropDown.dart';
import 'package:acceso_residencial/helpers/validarCamposVacios.dart';
import 'package:acceso_residencial/main.dart';
import 'package:acceso_residencial/pages/login.dart';
import 'package:acceso_residencial/provider/crearCodigo.dart';
import 'package:acceso_residencial/provider/validacion.dart';
import 'package:acceso_residencial/widgets/boton.dart';
import 'package:acceso_residencial/widgets/custom_input.dart';
import 'package:acceso_residencial/widgets/texto.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';



class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  TextEditingController nombreController= TextEditingController();
  TextEditingController apellidosController= TextEditingController();
  TextEditingController torreController= TextEditingController();
  TextEditingController apartamentoController= TextEditingController();
  TextEditingController correoController= TextEditingController();
  TextEditingController celularController= TextEditingController();
  TextEditingController empresaController= TextEditingController();
  String actor='';
  @override
  Widget build(BuildContext context) {
    
    final createCode= Provider.of<Crearcodigo>(context);
    actor=createCode.actor;
    if(createCode.isCreatedCode){
       
       guardarUsuario(createCode);
       createCode.codeEnd(false);
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: titulo('Crea codigos de acceso',15.0, Colors.blue[600],EdgeInsets.only(left: 0,bottom: 15,right: 10,top: 20)),
        actions: [
        
         GestureDetector(
             onTap: ()async{
             
              await logoutUsser();
              Navigator.pushReplacementNamed(context, 'login');
              
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
               radius: 15.0,
               //backgroundImage: CachedNetworkImageProvider(validacion.urlPhoto),
              ),
            ),
          ), 
           
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            
            CustomInput(icon:Icons.person,placeholder:'Nombre', textController:nombreController,keyboardType:TextInputType.text,isPassword: false), 
            CustomInput(icon:Icons.person,placeholder:'Apellidos', textController:apellidosController,keyboardType:TextInputType.text,isPassword: false), 
           
            actor.contains('Portero')
            ?CustomInput(icon:Icons.compare,placeholder:'Empresa', textController:empresaController,keyboardType:TextInputType.text,isPassword: false)
            :actor.contains('Residente')?
            CustomInput(icon:Icons.adb,placeholder:'Torre', textController:torreController,keyboardType:TextInputType.number,isPassword: false)
            :Container(), 
           
             actor.contains('Residente')
             ?CustomInput(icon:Icons.aspect_ratio,placeholder:'Apartamento', textController:apartamentoController,keyboardType:TextInputType.text,isPassword: false)
             :Container(), 

            CustomInput(icon:Icons.email,placeholder:'Correo', textController:correoController,keyboardType:TextInputType.text,isPassword: false), 
            CustomInput(icon:Icons.phone,placeholder:'Celular', textController:celularController,keyboardType:TextInputType.number,isPassword: false), 
            SizedBox(height: 10),
            Titulo(texto:'Escoja el tipo de usuario', size:15,color: Colors.grey,padding: EdgeInsets.only(left:45),),
            SizedBox(height: 5),
            DropDownWidget(),
            SizedBox(height: 20),
            Boton(label: 'Crear codigo') 
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

   guardarUsuario(final createCode)async{
     
      Map<String,dynamic> datos= Map();
      String codigo='';
      datos['nombre']     =nombreController.text;
      datos['apellidos']  =apellidosController.text;
      datos['celular']    =celularController.text;
      actor=='Residente'?datos['torre']=torreController.text:(){};
      actor=='Residente'?datos['apartamento']=apartamentoController.text:(){};
      datos['correo']     =correoController.text;
      actor=='Portero'?datos['empresa']=empresaController.text:(){};
      //datos['codigo']     =nombreController.text;
      actor= createCode.actor;
      print('------>');
      print(actor);
      codigo= Uuid().v5(datos['nombre'],datos['apellidos']).substring(0,23);
     
      
      
     

      if(!validarCamposVacios(datos)){
        mensajePantalla('LLene los campos vacios');
      }else if(actor=='Portero'){
         codigos.doc(codigo).set({
           'nombre'      :nombreController.text,
           'apellidos'   :apellidosController.text,
           'celular'     :celularController.text,
           'correo'      :correoController.text,
           'codigo'      :codigo,
           'tipoUsuario' :actor,
           'empresa'     :empresaController.text
        
       }); 
       nombreController.clear();
       apellidosController.clear();
       celularController.clear();
       correoController.clear();
       empresaController.clear();

       mensajePantalla('Codigo generado exitosamente!');
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
       nombreController.clear();
       apellidosController.clear();
       celularController.clear();
       torreController.clear();
       apartamentoController.clear();
       correoController.clear();

       mensajePantalla('Codigo generado exitosamente!');
      }else if(actor=='administrador'){
         codigos.doc(codigo).set({
           'nombre'      :nombreController.text,
           'apellidos'   :apellidosController.text,
           'celular'     :celularController.text,
           'correo'      :correoController.text,
           'codigo'      :codigo,
           'tipoUsuario' :actor 
        
       }); 
       nombreController.clear();
       apellidosController.clear();
       celularController.clear();
       correoController.clear();

       mensajePantalla('Codigo generado exitosamente!');
      }
   }

    logoutUsser(){
    gSignIn.signOut();
  }
}
        
        
        