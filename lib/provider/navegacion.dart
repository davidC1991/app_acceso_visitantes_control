import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NavegacionModel with ChangeNotifier{
  int _paginaActual=0;
  PageController _pageController= PageController();
  String _tituloPantalla='Genera permiso a tu visita';
  
  int get paginaActual=>this._paginaActual;
  String get tituloPantalla=>this._tituloPantalla;


  setTituloPantalla(String titulo){
    this._tituloPantalla=titulo;
    notifyListeners();
  }

  set paginaActual(int valor){
    this._paginaActual=valor;
    _pageController.animateToPage(valor, duration:Duration(milliseconds: 250) , curve: Curves.bounceIn);
    notifyListeners();
  }

  PageController get pageController =>this._pageController;
}