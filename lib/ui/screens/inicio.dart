import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simulador_cargas/core/app_colors.dart';
import 'package:simulador_cargas/ui/screens/app_home.dart';


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
      // 1. El Scaffold ya se encarga del color de fondo en toda la pantalla
      backgroundColor: AppColors.fondo, 
      body: Stack(
        children: [

          Positioned(
  // 1. Lo posicionamos a un 15% de la pantalla medido desde abajo hacia arriba
  bottom: screenHeight * 0.4, 
  // 2. Centrado horizontalmente (restando la mitad del ancho del botón)
  left: (screenwidth / 2) - (screenwidth * 0.15), 
  
  //boton inicio
  child: ElevatedButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AppHome()),
      );
    },
    style: ElevatedButton.styleFrom(
      // Cambiamos el color de fondo de manera limpia
      backgroundColor: AppColors.botoniniciar,
      // Le damos un tamaño adaptativo (50% del ancho de pantalla y 55 píxeles de alto)
      fixedSize: Size(screenwidth * 0.5, screenHeight *0.1),
      // Bordes redondeados estéticos
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
    ),
    child: Center(
      child: Text(
        'Iniciar',
        style: GoogleFonts.sniglet(
          // Ajustado a un tamaño legible (aprox 16-20 píxeles dependiendo del dispositivo)
          fontSize: screenwidth * 0.03, 
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    ),
  ),
),

          Positioned(
            bottom: screenHeight - (screenwidth * 0.75),
            right: screenwidth * 0.4, 
            child: Image.asset(
              "assets/images/Inicio.gif",
              width: screenwidth * 0.8,
              height: screenwidth * 0.8,
            ),
          ),
      Positioned(
        bottom: screenHeight - (screenwidth * 0.2),
            right: screenwidth * 0.05,
        child: Text("Simulador de cargas",style:GoogleFonts.dynaPuff(
          fontSize: screenwidth *0.07,
    fontWeight: FontWeight.bold,
    color: Colors.black,),)
        ),
        
        Positioned(
          bottom: screenHeight - (screenwidth * 0.1),
            right: screenwidth * 0.9,
          child: Image.asset("assets/images/positiva.png",
          width: screenwidth * 0.05,
              height: screenwidth * 0.05,
          )
          ),

Positioned(
          bottom: screenHeight - (screenwidth * 0.1),
            right: screenwidth * 0.05,
          child: Image.asset("assets/images/negativa.png",
          width: screenwidth * 0.05,
              height: screenwidth * 0.05,
          )
          ),

          
        ],
      ),
    );
  }
}