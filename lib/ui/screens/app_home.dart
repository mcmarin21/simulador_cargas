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
          actions: [
            Row(
              children: [
                const Text("1D", style: TextStyle(fontWeight: FontWeight.bold)),
                Switch(
  value: esModo2D,
  activeColor: Colors.blueAccent,
  onChanged: (valor) {
    setState(() {
      esModo2D = valor; // Alterna el modo y Flutter redibuja todo automáticamente respetando las posiciones originales
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
  child: LayoutBuilder(
    builder: (context, constraintsDerecha) {
      // 1. Ahora calculamos los centros basados ÚNICAMENTE en el espacio de dibujo
      final centroX = constraintsDerecha.maxWidth / 2;
      final centroY = constraintsDerecha.maxHeight / 2;

      return DragTarget<Carga>(
        onWillAcceptWithDetails: (details) => true,
        onAcceptWithDetails: (details) {
          final renderBox = context.findRenderObject() as RenderBox;
          final posicionLocal = renderBox.globalToLocal(details.offset);

          setState(() {
            int indexReal = cargas.indexWhere((c) => c.id == details.data.id);
            if (indexReal != -1) {
              double centroEsferaX = posicionLocal.dx + 18;
              double centroEsferaY = posicionLocal.dy + 18;
              
              double pixelesX = centroEsferaX - centroX;
              double pixelesY = centroEsferaY - centroY;
              
              double valorXCrudo = pixelesX / 40.0;
              double valorYCrudo = -(pixelesY / 40.0); 

              cargas[indexReal].pos.x = valorXCrudo.roundToDouble().clamp(-10.0, 10.0);
              cargas[indexReal].pos.y = esModo2D ? valorYCrudo.roundToDouble().clamp(-10.0, 10.0) : 0.0; 
            }
          });
        },
        builder: (context, candidateData, rejectedData) {
          return Container(
            color: Colors.grey[950],
            child: Stack(
              children: [
                // Fondo del Plano/Regla
                Positioned.fill(
                  child: CustomPaint(
                    painter: SimuladorPainter(
                      cargas: cargas,
                      cargaSeleccionada: _cargaSeleccionada,
                      esModo2D: esModo2D,
                    ),
                  ),
                ),
                // Renderizado de las cargas (Esferas)
                ...cargas.map((c) {
  bool seleccionada = _cargaSeleccionada?.id == c.id;
  Color colorC = c.magnitud > 0 ? Colors.red : Colors.blue;

  // La posición X siempre se mapea igual utilizando nuestra escala de 40.0 píxeles
  double posicionPantallaX = centroX + (c.pos.x * 40.0) - 18;
  
  // --- AQUÍ ESTÁ EL TRUCO PARA EL RETORNO DE MODO ---
  // Si estamos en modo 2D, usamos el valor 'y' real ingresado en el teclado.
  // Si estamos en modo 1D, forzamos visualmente que se dibuje sobre la regla (0.0 unidades matemáticas).
  double coordenadaYMatematica = esModo2D ? c.pos.y : 0.0;
  
  // Convertimos esa coordenada matemática a píxeles de pantalla reales invertidos
  double posicionPantallaY = centroY - (coordenadaYMatematica * 40.0) - 18;

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
      );
    }
  ),
),
          ],
        ),
      );
    });
  }
}
  