import 'package:http/http.dart' as http;

class EnviarMensaje{


  Future envioMsm(String numero, String mensaje)async{
    String usuarioMsm='david.callejasc@hotmail.es';
    String passwordMsm='gzkXU-VHHL';
    String url='https://sistemasmasivos.com/itcloud/api/sendsms/send.php?user='+ usuarioMsm + '&password='+passwordMsm +'&GSM=57'+numero+'&SMSText='+mensaje;
    //final resp = await http.get(url);
    //print(resp.body);
  }

}