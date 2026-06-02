import 'package:flutter/material.dart';
import 'package:simulador_cargas/domain/carga.dart';
import 'package:simulador_cargas/domain/simulator_painter.dart';
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
        var tamanoDer = tamMax - _tamanoDivisor - tamanoIzq;

        return Scaffold(
          appBar: AppBar(
            actions: [
              Row(
                children: [
                  const Text(
                    "1D",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Switch(
                    value: esModo2D,
                    activeColor: Colors.blueAccent,
                    onChanged: (valor) {
                      setState(() {
                        esModo2D =
                            valor; // Alterna el modo y Flutter redibuja todo automáticamente respetando las posiciones originales
                      });
                    },
                  ),
                  const Text(
                    "2D",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            ],
          ),
          body: Row(
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

              PanelViewport(cargas: cargas, modo2D: esModo2D),
            ],
          ),
        );
      },
    );
  }
}
