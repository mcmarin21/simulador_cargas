import 'package:flutter/material.dart';
import 'package:simulador_cargas/core/app_colors.dart';


Widget responsiveBox({
  required Widget child,
  double widthFactor = 1.0,  // Por defecto toma el 100% del ancho
  double heightFactor = 1.0, // Por defecto toma el 100% del alto
  Alignment alignment = Alignment.center, // Por defecto se alinea al centro
}) {
  return FractionallySizedBox(
    widthFactor: widthFactor,
    heightFactor: heightFactor,
    alignment: alignment,
    child: child,
  );
}

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  @override
  Widget build(BuildContext context) {


  final double screenHeight = MediaQuery.of(context).size.height;
  final double screenwidth = MediaQuery.of(context).size.width;


    return Scaffold(
      backgroundColor: AppColors.fondo,
        body: Stack(
          children: [   
           Positioned(
                top: screenHeight * 0.5,
                right:screenwidth * 0.5,
                child: 
                Image.asset("assets/images/Inicio.gif", height: screenwidth * 0.3,
                width: screenwidth * 0.3)
              ),
          ],
        ),
    );
  }
}