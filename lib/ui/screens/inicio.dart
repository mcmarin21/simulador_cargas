import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simulador_cargas/core/app_colors.dart';


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
            right: screenwidth * 0.4,
        child: Text("Simulador de cargas",style:GoogleFonts.dynaPuff(
          fontSize: 26,
    fontWeight: FontWeight.bold,
    color: Colors.black,),)
        )
        ],
      ),
    );
  }
}