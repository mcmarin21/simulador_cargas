import 'package:flutter/material.dart';
import 'package:simulador_cargas/domain/carga.dart';
import 'package:simulador_cargas/domain/vector.dart';
import 'package:simulador_cargas/ui/components/divisor_horizontal.dart';
import 'package:simulador_cargas/ui/panels/panel_cargas.dart';

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

  void agregarCarga(Carga carga) {
    setState(() {
      cargas.add(carga);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final tamMax = constraints.maxWidth;

      var tamanoIzq = (tamMax - _tamanoDivisor) * _fracIzquierda;
      var tamanoDer = tamMax - _tamanoDivisor - tamanoIzq;

      return Scaffold(
        body: Row(
          children: [
            // LADO IZQUIERDO: Panel donde creas y ves la lista de cargas "semillero"
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
            
            // EL DIVISOR AJUSTABLE
            DivisorHorizontal(
              width: _tamanoDivisor,
              onDragUpdate: (details) {
                setState(() {
                  final delta = details.delta.dx / tamMax;
                  _fracIzquierda = (_fracIzquierda + delta).clamp(_fracMin, 1 - _fracMin);
                });
              },
            ),
            
            // LADO DERECHO: ZONA DE CAÍDA E INTERACCIÓN INTERACTIVA
            SizedBox(
              width: tamanoDer,
              child: DragTarget<Carga>(
                onWillAcceptWithDetails: (details) => true,
                onAcceptWithDetails: (details) {
                  // Capturamos las coordenadas relativas EXCLUSIVAMENTE de este lado derecho
                  final renderBox = context.findRenderObject() as RenderBox;
                  final posicionGlobal = details.offset;
                  
                  // Convertimos la posición global del mouse a la posición local del simulador
                  final posicionLocal = renderBox.globalToLocal(posicionGlobal);

                  setState(() {
                    Carga cargaArrastrada = details.data;
                    
                    // Ajustamos la posición restando el ancho del panel izquierdo y del divisor
                    // para que calce exactamente donde soltaste el mouse/dedo
                    cargaArrastrada.pos.x = posicionLocal.dx - tamanoIzq - _tamanoDivisor;
                    cargaArrastrada.pos.y = posicionLocal.dy;
                  });
                },
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    color: Colors.grey[900], // Fondo oscuro para que resalten las cargas y vectores
                    child: Stack(
                      children: [
                        // Mensaje de guía de fondo si ninguna carga se ha posicionado todavía
                        if (cargas.every((c) => c.pos.x == 0 && c.pos.y == 0))
                          const Center(
                            child: Text(
                              "Arrastra las cargas del panel izquierdo aquí",
                              style: TextStyle(color: Colors.white30, fontSize: 16),
                            ),
                          ),

                        // Renderizamos en el plano las cargas que ya tienen coordenadas
                        ...cargas.map((c) {
                          // Si sigue en el origen (0,0), asumimos que no ha sido arrastrada al plano
                          if (c.pos.x == 0 && c.pos.y == 0) return const SizedBox.shrink();

                          // Definimos colores según el signo de la carga
                          Color colorCarga = c.magnitud > 0 ? Colors.red : (c.magnitud < 0 ? Colors.blue : Colors.grey);
                          IconData iconoCarga = c.magnitud > 0 ? Icons.add_circle : (c.magnitud < 0 ? Icons.remove_circle : Icons.circle_outlined);

                          return Positioned(
                            left: c.pos.x - 20, // Centramos el ícono (mitad del tamaño de 40)
                            top: c.pos.y - 20,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(iconoCarga, color: colorCarga, size: 40),
                                Text(
                                  c.nombre,
                                  style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          );
                        }),

                        // ========================================================
                        // AQUÍ EN EL FUTURO COLOCARÁS LA GRÁFICA DE LAS INTERACCIONES
                        // Recorriendo la lista 'cargas' y usando un CustomPainter para 
                        // pintar las líneas resultantes de tus funciones físicas.
                        // ========================================================
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}