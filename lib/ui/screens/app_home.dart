import 'package:flutter/material.dart';
import 'package:simulador_cargas/domain/carga.dart';
import 'package:simulador_cargas/ui/panels/panel_cargas.dart';
import 'package:simulador_cargas/ui/components/divisor_horizontal.dart';
import 'package:simulador_cargas/ui/panels/panel_viewport.dart';

class AppHome extends StatefulWidget {
  const AppHome({super.key});

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  static const double _tamanoDivisor = 8.0;
  static const double _fracMin = 0.25;

  double _fracIzquierda = _fracMin;
  List<Carga> cargas = [];

  // Variable de estado para controlar el modo 1D / 2D
  bool esModo2D = true;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final tamMax = constraints.maxWidth;
        var tamanoIzq = (tamMax - _tamanoDivisor) * _fracIzquierda;

        return Row(
          children: [
            SizedBox(
              width: tamanoIzq,
              child: PanelCargas(
                cargas: cargas,
                onCargaAgregada: (nuevaCarga) {
                  setState(() {
                    cargas.add(nuevaCarga);
                  });
                },
                onCargaEliminada: (cargaEliminada) {
                  setState(() {
                    cargas.remove(cargaEliminada);
                  });
                },
                onCargaEditada: (cargaEditada) {
                  setState(() {
                    final index = cargas.indexOf(cargaEditada);
                    if (index != -1) cargas[index] = cargaEditada;
                  });
                },
              ),
            ),

            DivisorHorizontal(
              width: _tamanoDivisor,
              onDragUpdate: (details) {
                setState(() {
                  final delta = details.delta.dx / tamMax;
                  _fracIzquierda = (_fracIzquierda + delta).clamp(
                    _fracMin,
                    1 - _fracMin,
                  );
                });
              },
            ),

            PanelViewport(
              cargas: cargas,
              modo2D: esModo2D,
              onCargasChanged: (nuevasCargas) {
                setState(() => cargas = nuevasCargas);
              },
              onDimensionChange: () {
                setState(() => esModo2D = !esModo2D);
              },
            ),
          ],
        );
      },
    );
  }
}
