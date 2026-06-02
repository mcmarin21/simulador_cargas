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
    return Scaffold(
      backgroundColor: AppColors.fondo,
        body: Stack(
          children: [
            responsiveBox(
                widthFactor: 0.3,
                heightFactor: 0.3,
              child: Center(
                child: 
                Image.asset("assets/images/Inicio.gif")
              ),
            )
          ],
        ),
    );
  }
}