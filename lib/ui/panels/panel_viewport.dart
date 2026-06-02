import 'package:flutter/material.dart';

import '../../domain/carga.dart';
import '../../domain/simulator_painter.dart';

class PanelViewport extends StatefulWidget{

  final List<Carga> cargas;
  final bool modo2D;
  final ValueChanged<List<Carga>> onCargasChanged;

  const PanelViewport({
    required this.cargas,
    required this.modo2D,
    required this.onCargasChanged,
    super.key,
  });

  @override
  State createState() => _PanelViewportState();
}

class _PanelViewportState extends State<PanelViewport>{

  Carga? _cargaSeleccionada;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraintsDerecha) {
          // 1. Ahora calculamos los centros basados ÚNICAMENTE en el espacio de dibujo
          final centroX = constraintsDerecha.maxWidth / 2;
          final centroY = constraintsDerecha.maxHeight / 2;

          return DragTarget<Carga>(
            onWillAcceptWithDetails: (details) => true,
            onAcceptWithDetails: (details) {
              final renderBox =
              context.findRenderObject() as RenderBox;
              final posicionLocal = renderBox.globalToLocal(
                details.offset,
              );

              setState(() {
                int indexReal = widget.cargas.indexWhere(
                      (c) => c.id == details.data.id,
                );
                if (indexReal != -1) {
                  double centroEsferaX = posicionLocal.dx + 18;
                  double centroEsferaY = posicionLocal.dy + 18;

                  double pixelesX = centroEsferaX - centroX;
                  double pixelesY = centroEsferaY - centroY;

                  double valorXCrudo = pixelesX / 40.0;
                  double valorYCrudo = -(pixelesY / 40.0);

                  widget.cargas[indexReal].pos.x = valorXCrudo
                      .roundToDouble()
                      .clamp(-10.0, 10.0);
                  widget.cargas[indexReal].pos.y = widget.modo2D
                      ? valorYCrudo.roundToDouble().clamp(-10.0, 10.0)
                      : 0.0;
                  widget.onCargasChanged(List.from(widget.cargas));
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
                          cargas: widget.cargas,
                          cargaSeleccionada: _cargaSeleccionada,
                          esModo2D: widget.modo2D,
                        ),
                      ),
                    ),
                    // Renderizado de las cargas (Esferas)
                    ...widget.cargas.map((c) {
                      bool seleccionada =
                          _cargaSeleccionada?.id == c.id;
                      Color colorC = c.magnitud > 0
                          ? Colors.red
                          : Colors.blue;

                      // La posición X siempre se mapea igual utilizando nuestra escala de 40.0 píxeles
                      double posicionPantallaX =
                          centroX + (c.pos.x * 40.0) - 18;

                      // --- AQUÍ ESTÁ EL TRUCO PARA EL RETORNO DE MODO ---
                      // Si estamos en modo 2D, usamos el valor 'y' real ingresado en el teclado.
                      // Si estamos en modo 1D, forzamos visualmente que se dibuje sobre la regla (0.0 unidades matemáticas).
                      double coordenadaYMatematica = widget.modo2D
                          ? c.pos.y
                          : 0.0;

                      // Convertimos esa coordenada matemática a píxeles de pantalla reales invertidos
                      double posicionPantallaY =
                          centroY -
                              (coordenadaYMatematica * 40.0) -
                              18;

                      return Positioned(
                        key: ValueKey(c.id),
                        left: posicionPantallaX,
                        top: posicionPantallaY,
                        child: Draggable<Carga>(
                          data: c,
                          feedback: CircleAvatar(
                            radius: 18,
                            backgroundColor: colorC.withOpacity(0.7),
                          ),
                          childWhenDragging: const SizedBox.shrink(),
                          child: GestureDetector(
                            onTap: () => setState(
                                  () => _cargaSeleccionada = seleccionada
                                  ? null
                                  : c,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: seleccionada
                                      ? Theme.of(context).colorScheme.secondary
                                      : Colors.white,
                                  width: seleccionada ? 3 : 1,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 18,
                                backgroundColor: colorC,
                                child: Text(
                                  c.magnitud > 0 ? "+" : "-",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
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
        },
      ),
    );
  }
}