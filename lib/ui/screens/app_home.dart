import 'package:flutter/material.dart';
import 'package:simulador_cargas/ui/components/divisor_horizontal.dart';
import 'package:simulador_cargas/ui/panels/panel_cargas.dart';

class AppHome extends StatefulWidget {
  const AppHome({super.key});

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome>{

  double fracIzquierda = 0.4;

  static const double _tamanoDivisor = 8.0;
  static const double _fracMin = 0.4;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final tamMax = constraints.maxWidth;

      var tamanoIzq = (tamMax - _tamanoDivisor) * fracIzquierda;
      var tamanoDer = tamMax - _tamanoDivisor - tamanoIzq;

      return Row(
        children: [
          SizedBox(
            width: tamanoIzq,
            child: PanelCargas(),
          ),
          DivisorHorizontal(
            width: _tamanoDivisor,
            onDragUpdate: (details) {

            },
          ),
          SizedBox(
            width: tamanoDer,
          )
        ],
      );
    });
  }
}