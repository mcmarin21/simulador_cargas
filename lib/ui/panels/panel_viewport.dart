import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../domain/carga.dart';
import '../../domain/simulator_painter.dart';

class PanelViewport extends StatefulWidget{

  final List<Carga> cargas;
  final bool modo2D;
  final ValueChanged<List<Carga>> onCargasChanged;
  final GestureTapCallback onDimensionChange;

  const PanelViewport({
    required this.cargas,
    required this.modo2D,
    required this.onCargasChanged,
    required this.onDimensionChange,
    super.key,
  });

  @override
  State createState() => _PanelViewportState();
}

class _PanelViewportState extends State<PanelViewport>{

  double _escala = 40.0;
  Offset _origen = Offset.zero;
  Size _canvasSize = Size.zero;
  Offset _focalPointStart = Offset.zero;
  Offset _origenAlIniciar = Offset.zero;
  double _escalaAlIniciar = 40.0;
  double _lastEscala = 1.0;
  int _draggingIndex = -1;

  Offset _toMath(Offset tap, Size size) {
    final cx = size.width / 2 + _origen.dx;
    final cy = size.height / 2 + _origen.dy;
    return Offset((tap.dx - cx) / _escala, (cy - tap.dy) / _escala);
  }

  int _hitTestCarga(Offset localPosition, Size size) {
    final cx = size.width / 2 + _origen.dx;
    final cy = size.height / 2 + _origen.dy;
    for (int i = 0; i < widget.cargas.length; i++) {
      final px = cx + widget.cargas[i].pos.dx * _escala;
      final py = cy - widget.cargas[i].pos.dy * _escala;
      final target = widget.modo2D ? Offset(px, py) : Offset(px, cy);
      final dist = widget.modo2D
          ? (localPosition - target).distance
          : (localPosition.dx - target.dx).abs();
      if (dist < 8) return i;
    }
    return -1;
  }

  void _zoomEnCursor(Offset cursor, double ratio) {
    final oldEscala = _escala;
    final newEscala = (_escala * ratio).clamp(10.0, 150.0);

    final cx = _canvasSize.width / 2 + _origen.dx;
    final cy = _canvasSize.height / 2 + _origen.dy;
    final mathX = (cursor.dx - cx) / oldEscala;
    final mathY = (cy - cursor.dy) / oldEscala;

    _origen = Offset(
      cursor.dx - _canvasSize.width / 2 - mathX * newEscala,
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
            onPointerSignal: (event) {
              if (event is PointerScrollEvent) {
                setState(() {
                  final ratio = event.scrollDelta.dy > 0 ? 0.95 : 1.05;
                  _zoomEnCursor(event.localPosition, ratio);
                });
              }
            },
            child: Stack(
              children: [
                GestureDetector(
                  onScaleStart: (details) {
                    final hit = _hitTestCarga(details.localFocalPoint, _canvasSize);
                    _draggingIndex = hit;
                    _lastEscala = 1.0;

                    if (hit == -1) {
                      _focalPointStart = details.localFocalPoint;
                      _origenAlIniciar = _origen;
                      _escalaAlIniciar = _escala;
                    }
                  },
                  onScaleUpdate: (details) {
                    setState(() {
                      if (_draggingIndex >= 0) {
                        final math = _toMath(details.localFocalPoint, _canvasSize);
                        final c = widget.cargas[_draggingIndex];

                        widget.cargas[_draggingIndex].pos = widget.modo2D
                            ? math
                            : Offset(math.dx, c.pos.dy);
                        widget.onCargasChanged(List.from(widget.cargas));
                      } else {
                        final ratio = details.scale / _lastEscala;
                        _lastEscala = details.scale;
                        final newEscala = (_escala * ratio).clamp(10.0, 150.0);

                        final pan = details.localFocalPoint - _focalPointStart;
                        final cx = _canvasSize.width  / 2 + _origenAlIniciar.dx + pan.dx;
                        final cy = _canvasSize.height / 2 + _origenAlIniciar.dy + pan.dy;
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
                  child: CustomPaint(
                    painter: SimuladorPainter(
                        cargas: widget.cargas,
                        escala: _escala,
                        origen: _origen,
                        esModo2D: widget.modo2D,
                        indexSeleccionada: _draggingIndex,
                        colorScheme: Theme.of(context).colorScheme
                    ),
                    size: _canvasSize,
                  )
                ),

                Positioned(
                  top: 12,
                  right: 12,
                  child: TextButton(
                    onPressed: widget.onDimensionChange,
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    child: Text(
                      widget.modo2D ? "1D" : "2D",
                      style: TextTheme.of(context).titleMedium,
                    ),
                  ),
                )
              ],
            )
          );
        },
      ),
    );
  }
}