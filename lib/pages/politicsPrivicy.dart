import 'package:flutter/material.dart';

class PoliticsAndPrivicy extends StatelessWidget {
   
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
      ),
      body: SingleChildScrollView(
        child:Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10,bottom: 10),
                child: Center(child: Text('POLÍTICA DE PRIVACIDAD',style:TextStyle(fontWeight: FontWeight.bold))),
              ),
              Text('El presente Política de Privacidad establece los términos en que Jesus David Callejas Cabarcas usa y protege la información que es proporcionada por sus usuarios al momento de utilizar su sitio web. Esta compañía está comprometida con la seguridad de los datos de sus usuarios. Cuando le pedimos llenar los campos de información personal con la cual usted pueda ser identificado, lo hacemos asegurando que sólo se empleará de acuerdo con los términos de este documento. Sin embargo esta Política de Privacidad puede cambiar con el tiempo o ser actualizada por lo que le recomendamos y enfatizamos revisar continuamente esta página para asegurarse que está de acuerdo con dichos cambios.',textAlign: TextAlign.justify),
              Padding(
                padding: const EdgeInsets.only(top: 10,bottom: 10),
                child: Text('Información que es recogida',style:TextStyle(fontWeight: FontWeight.bold)),
              ),
              Text('Nuestro aplicativo movil podrá recoger información personal por ejemplo: Nombre,   información de contacto como  su dirección de correo electrónica . Así mismo cuando sea necesario podrá ser requerida.',textAlign: TextAlign.justify),
              Padding(
                padding: const EdgeInsets.only(top: 10,bottom: 10),
                child: Text('Uso de la información recogida.',style:TextStyle(fontWeight: FontWeight.bold)),
              ),
              Text('Nuestro aplicativo movil emplea la información con el fin de proporcionar el mejor servicio posible, particularmente para mantener un registro de usuarios, con el fin de mejorar nuestros servicios.  Es posible que sean enviados correos electrónicos periódicamente o mensajes de texto con informacion pertienente del servicio, nuevas actualizaciones y otra información publicitaria que consideremos relevante para usted o que pueda brindarle algún beneficio, estos correos electrónicos serán enviados a la dirección que usted proporcione y podrán ser cancelados en cualquier momento.Jesus David Callejas Cabarcas está altamente comprometido para cumplir con el compromiso de mantener su información segura. Usamos los sistemas más avanzados y los actualizamos constantemente para asegurarnos que no exista ningún acceso no autorizado.',textAlign: TextAlign.justify),
              Padding(
                padding: const EdgeInsets.only(top: 10,bottom: 10),
                child: Text('Control de su información personal',style:TextStyle(fontWeight: FontWeight.bold)),
              ),
              Text('Esta compañía no venderá, cederá ni distribuirá la información personal que es recopilada sin su consentimiento, salvo que sea requerido por un juez con un orden judicial.',textAlign: TextAlign.justify),
              Text('1 - A través de esta aplicación no se recaban datos de carácter personal de los usuarios.',textAlign: TextAlign.left),
              Text('2 - No se registran direcciones IP.',textAlign: TextAlign.left),
              Text('3 - No se accede a las cuentas de correo de los usuarios.',textAlign: TextAlign.left),
              Text('4 - La aplicación no guarda datos ni hace seguimientos sobre tiempos y horarios de utilización.',textAlign: TextAlign.left),
              Text('5 - La aplicación no guarda información relativa a tu dispositivo como, por ejemplo, fallos, actividad del sistema, ajustes del hardware, tipo de navegador, idioma del navegador.',textAlign: TextAlign.justify),
              Text('6 - La aplicación no accede a tus contactos ni agendas.',textAlign: TextAlign.left),
              Text('7 - La aplicación no recopila información sobre tu ubicación real.',textAlign: TextAlign.left),
              Text('8 - Clasificación por edades: PEGI 3 - Apto para todos los públicos.',textAlign: TextAlign.left),
              Text('9 - Cargos y cuotas: El uso de esta aplicación es totalmente gratuito.',textAlign: TextAlign.left),
              Text('10 - Cambios en nuestra Política de Privacidad: Nuestra Política de Privacidad puede cambiar de vez en cuando.',textAlign: TextAlign.left),
              Text('11 - Google no tiene responsabilidad sobre los servicios de esta aplicativo movil.',textAlign: TextAlign.left),
              Text('12 - La aplicacion pide permiso al usuario para acceder a la camara, con el fin de poder capturar el codigo QR y proceder a interpretarlo, bajo ninguna circunstancia se accede a galeria o se intervienen en archivos locales del movil.',textAlign: TextAlign.justify),

              
            ],
          ),
        )
      ),
    );
  }
}