import 'package:flutter/material.dart';
import 'package:simulador_cargas/ui/components/divisor_horizontal.dart';
import 'package:simulador_cargas/ui/panels/panel_cargas.dart';

class AppHome extends StatefulWidget {
  const AppHome({super.key});

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome>{


  static const double _tamanoDivisor = 8.0;
  static const double _fracMin = 0.25;

  double _fracIzquierda = _fracMin;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final tamMax = constraints.maxWidth;

      var tamanoIzq = (tamMax - _tamanoDivisor) * _fracIzquierda;
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
              setState(() {
                final delta = details.delta.dx / tamMax;
                _fracIzquierda = (_fracIzquierda + delta).clamp(_fracMin, 1 - _fracMin,);
              });
            },
          ),
          SizedBox(
            width: tamanoDer,
          ),
        ],
      );
    });
  }
}