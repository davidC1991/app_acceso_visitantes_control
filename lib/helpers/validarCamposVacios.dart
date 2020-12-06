

bool validarCamposVacios(Map<String,dynamic> datos){
   bool isValid=true;
   datos.forEach((key, value) { 
      if( value.isEmpty){
        isValid=false;
        //print('$key-->$value');
      }
      
    });

    return isValid;

}
