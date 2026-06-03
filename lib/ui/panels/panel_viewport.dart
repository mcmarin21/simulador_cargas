import 'package:flutter/gestures.dart';
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
  double _escala = 40.0;
  Offset _origen = Offset.zero;
  Size _canvasSize = Size.zero;
  Offset _focalPointStart = Offset.zero;
  Offset _origenAlIniciar = Offset.zero;
  double _escalaAlIniciar = 40.0;
  double _lastScale = 1.0;
  int _draggingIndex = -1;

  Offset _PixelCoords(Offset tap) {
    final cx = _canvasSize.width  / 2 + _origen.dx;
    final cy = _canvasSize.height / 2 + _origen.dy;
    return Offset((tap.dx - cx) / _escala, (cy - tap.dy) / _escala);
  }

  Offset _CoordsPixel(Offset math){
    final cx = _canvasSize.width  / 2 + _origen.dx;
    final cy = _canvasSize.height / 2 + _origen.dy;
    return Offset(cx + math.dx * _escala, cy - math.dy * _escala);
  }

  int _hitTestCarga(Offset local) {
    for (int i = 0; i < widget.cargas.length; i++) {
      final c    = widget.cargas[i];
      final posY = widget.modo2D ? c.pos.dy : 0.0;
      final px   = _CoordsPixel(Offset(c.pos.dx, posY));
      if ((local - px).distance < 24) return i;
    }
    return -1;
  }

  void _zoomEnCursor(Offset cursor, double ratio) {
    final oldEscala = _escala;
    final newEscala = (_escala * ratio).clamp(10.0, 150.0);

    final cx    = _canvasSize.width  / 2 + _origen.dx;
    final cy    = _canvasSize.height / 2 + _origen.dy;
    final mathX = (cursor.dx - cx) /  oldEscala;
    final mathY = (cy - cursor.dy) /  oldEscala;

    _origen = Offset(
      cursor.dx - _canvasSize.width  / 2 - mathX * newEscala,
      cursor.dy - _canvasSize.height / 2 + mathY * newEscala,
    );
    _escala = newEscala;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_canvasSize != constraints.biggest) {
              setState(() => _canvasSize = constraints.biggest);
            }
          });

          return Listener(
            // Zoom con rueda del mouse / trackpad (scroll)
            onPointerSignal: (event) {
              if (event is PointerScrollEvent) {
                setState(() {
                  final ratio = event.scrollDelta.dy > 0 ? 0.95 : 1.05;
                  _zoomEnCursor(event.localPosition, ratio);
                });
              }
            },
            child: GestureDetector(
              // Tap: agregar carga si no hay ninguna en ese punto
              onTapUp: (details) {
                final hit = _hitTestCarga(details.localPosition);
                if (hit != -1) return; // tap sobre carga existente → no agregar

                final math = _PixelCoords(details.localPosition);

                // Evitar duplicados (tolerancia 0.5 unidades)
                final existe = widget.cargas.any((c) =>
                (c.pos.dx - math.dx).abs() < 0.5 &&
                    (c.pos.dy - math.dy).abs() < 0.5,
                );
                if (existe) return;

                // Aquí puedes emitir el nuevo punto si quieres agregarlo desde afuera,
                // o crear una Carga por defecto. Ajusta según tu lógica de negocio:
                // widget.onCargasChanged([...widget.cargas, Carga(pos: math, ...)]);
              },

              // Inicio del gesto (pan / zoom trackpad / arrastrar carga)
              onScaleStart: (details) {
                final hit = _hitTestCarga(details.localFocalPoint);
                _draggingIndex = hit;
                _lastScale     = 1.0;

                if (hit == -1) {
                  _focalPointStart = details.localFocalPoint;
                  _origenAlIniciar = _origen;
                  _escalaAlIniciar = _escala;
                }
              },

              // Actualización del gesto
              onScaleUpdate: (details) {
                setState(() {
                  if (_draggingIndex >= 0) {
                    // ── Mover carga ──────────────────────────────────────
                    final math = _PixelCoords(details.localFocalPoint);
                    final c    = widget.cargas[_draggingIndex];

                    widget.cargas[_draggingIndex].pos = widget.modo2D
                        ? math
                        : Offset(math.dx, c.pos.dy); // 1D: preserva Y

                    widget.onCargasChanged(List.from(widget.cargas));
                  } else {
                    // ── Pan + zoom juntos (trackpad pinch / pan) ─────────
                    final ratio     = details.scale / _lastScale;
                    _lastScale      = details.scale;
                    final newEscala = (_escala * ratio).clamp(10.0, 150.0);

                    final pan = details.localFocalPoint - _focalPointStart;
                    final cx  = _canvasSize.width  / 2 + _origenAlIniciar.dx + pan.dx;
                    final cy  = _canvasSize.height / 2 + _origenAlIniciar.dy + pan.dy;
                    final mathX = (details.localFocalPoint.dx - cx) / _escala;
                    final mathY = (cy - details.localFocalPoint.dy) / _escala;

                    _origen = Offset(
                      details.localFocalPoint.dx - _canvasSize.width  / 2 - mathX * newEscala,
                      details.localFocalPoint.dy - _canvasSize.height / 2 + mathY * newEscala,
                    );
                    _escala = newEscala;
                  }
                });
              },

              onScaleEnd: (_) => _draggingIndex = -1,

              child: Stack(
                children: [
                  // ── Plano / regla ──────────────────────────────────────
                  Positioned.fill(
                    child: CustomPaint(
                      painter: SimuladorPainter(
                        cargas:           widget.cargas,
                        escala:           _escala,
                        origen:           _origen,
                        esModo2D:         widget.modo2D,
                        indexSeleccionada: widget.cargas.indexWhere(
                              (c) => c.id == _cargaSeleccionada?.id,
                        ),
                        colorScheme: Theme.of(context).colorScheme,
                      ),
                    ),
                  ),

                  // ── Esferas (cargas) ───────────────────────────────────
                  ...widget.cargas.map((c) {
                    final seleccionada = _cargaSeleccionada?.id == c.id;
                    final colorC       = c.magnitud > 0 ? Colors.red : Colors.blue;

                    final posY   = widget.modo2D ? c.pos.dy : 0.0;
                    final pantalla = _CoordsPixel(Offset(c.pos.dx, posY));

                    return Positioned(
                      key:  ValueKey(c.id),
                      left: pantalla.dx - 18,
                      top:  pantalla.dy - 18,
                      child: GestureDetector(
                        onTap: () => setState(() =>
                        _cargaSeleccionada = seleccionada ? null : c,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            shape:  BoxShape.circle,
                            border: Border.all(
                              color: seleccionada
                                  ? Theme.of(context).colorScheme.secondary
                                  : Colors.white,
                              width: seleccionada ? 3 : 1,
                            ),
                          ),
                          child: CircleAvatar(
                            radius:          18,
                            backgroundColor: colorC,
                            child: Text(
                              c.magnitud > 0 ? '+' : '-',
                              style: const TextStyle(
                                color:      Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}