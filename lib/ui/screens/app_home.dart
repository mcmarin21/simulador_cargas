import 'package:flutter/material.dart';
import 'package:simulador_cargas/domain/carga.dart';
import 'package:simulador_cargas/domain/simulator_painter.dart';
import 'package:simulador_cargas/ui/panels/panel_cargas.dart';
import 'package:simulador_cargas/ui/components/divisor_horizontal.dart';

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
  Carga? _cargaSeleccionada;
  
  // Variable de estado para controlar el modo 1D / 2D
  bool esModo2D = true;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final tamMax = constraints.maxWidth;
      var tamanoIzq = (tamMax - _tamanoDivisor) * _fracIzquierda;
      var tamanoDer = tamMax - _tamanoDivisor - tamanoIzq;

      return Scaffold(
        appBar: AppBar(
          title: const Text("Simulador de Cargas"),
          actions: [
            Row(
              children: [
                const Text("1D", style: TextStyle(fontWeight: FontWeight.bold)),
                Switch(
                  value: esModo2D,
                  activeColor: Colors.greenAccent,
                  onChanged: (valor) {
                    setState(() {
                      esModo2D = valor;
                      // Si pasamos a 1D, forzamos a todas las cargas existentes a Y = 0
                      if (!esModo2D) {
                        for (var c in cargas) {
                          c.pos.y = 0;
                        }
                      }
                    });
                  },
                ),
                const Text("2D", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 20),
              ],
            )
          ],
        ),
        body: Row(
          children: [
            // TU PANEL IZQUIERDO AQUÍ (Omitido por brevedad)
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
            
            // DIVISOR
            DivisorHorizontal(
              width: _tamanoDivisor,
              onDragUpdate: (details) {
                setState(() {
                  final delta = details.delta.dx / tamMax;
                  _fracIzquierda = (_fracIzquierda + delta).clamp(_fracMin, 1 - _fracMin);
                });
              },
            ),

            // LADO DERECHO: PLANO 1D/2D
            Expanded(
              child: DragTarget<Carga>(
                onWillAcceptWithDetails: (details) => true,
                onAcceptWithDetails: (details) {
  final renderBox = context.findRenderObject() as RenderBox;
  final posicionLocal = renderBox.globalToLocal(details.offset);

  setState(() {
    final centroX = (tamMax - tamanoIzq - _tamanoDivisor) / 2;
    final centroY = constraints.maxHeight / 2;

    int indexReal = cargas.indexWhere((c) => c.id == details.data.id);
    if (indexReal != -1) {
      // 1. Calculamos la distancia en píxeles desde el centro (restando 18 por el radio de la esfera)
      double pixelesX = posicionLocal.dx - tamanoIzq - _tamanoDivisor - centroX + 18;
      double pixelesY = posicionLocal.dy - centroY + 18;
      
      // 2. Convertimos a unidades matemáticas (-10 a 10) dividiendo entre nuestra escala (40.0)
      cargas[indexReal].pos.x = (pixelesX / 40.0).clamp(-10.0, 10.0);
      
      // En Y, como el plano físico es invertido a la pantalla (positivo arriba), usamos el signo menos
      cargas[indexReal].pos.y = esModo2D ? (-(pixelesY / 40.0)).clamp(-10.0, 10.0) : 0.0; 
    }
  });
},
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    color: Colors.grey[950],
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CustomPaint(
                            painter: SimuladorPainter(
                              cargas: cargas,
                              cargaSeleccionada: _cargaSeleccionada,
                              esModo2D: esModo2D, // Pasamos la variable al dibujante
                            ),
                          ),
                        ),
                        
                        // Aquí va tu ...cargas.map para pintar las esferas

                        ...cargas.map((c) {
              bool seleccionada = _cargaSeleccionada?.id == c.id;
              Color colorC = c.magnitud > 0 ? Colors.red : Colors.blue;

              // Multiplicamos la coordenada matemática por 40.0 para saber cuántos píxeles pintarlo en pantalla
              double posicionPantallaX = (tamanoDer / 2) + (c.pos.x * 40.0) - 18;
              // Restamos en Y porque los valores positivos van hacia el extremo superior de la pantalla
              double posicionPantallaY = (constraints.maxHeight / 2) - (c.pos.y * 40.0) - 18;

              return Positioned(
                key: ValueKey(c.id),
                left: posicionPantallaX,
                top: posicionPantallaY,
                child: Draggable<Carga>(
                  data: c,
                  feedback: CircleAvatar(radius: 18, backgroundColor: colorC.withOpacity(0.7)),
                  childWhenDragging: const SizedBox.shrink(),
                  child: GestureDetector(
                    onTap: () => setState(() => _cargaSeleccionada = seleccionada ? null : c),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: seleccionada ? Colors.greenAccent : Colors.white, 
                          width: seleccionada ? 3 : 1
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: colorC,
                        child: Text(
                          c.magnitud > 0 ? "+" : "-", 
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
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
  