import 'dart:math';
import 'package:flutter/material.dart';
import 'package:simulador_cargas/domain/carga.dart';

class SimuladorPainter extends CustomPainter {
  final List<Carga> cargas;
  final double escala;
  final Offset origen;
  final bool esModo2D;
  final int indexSeleccionada;
  final ColorScheme colorScheme;

  SimuladorPainter({
    required this.cargas,
    required this.escala,
    required this.origen,
    required this.esModo2D,
    required this.indexSeleccionada,
    required this.colorScheme,
    super.repaint
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centro = Offset(
      size.width / 2 + origen.dx,
      size.height / 2 + origen.dy,
    );

    if (esModo2D) {
      _drawGrid(canvas, size, centro);
      _drawAxes(canvas, size, centro);
      _drawCargas(canvas, centro);
    } else {
      _drawNumberLine(canvas, size, centro);
      // _drawPointsOn1D(canvas, size, center);
    }
  }

  void _drawGrid(Canvas canvas, Size size, Offset centro) {
    final paint = Paint()
      ..color = colorScheme.onSurface.withValues(alpha: 0.25)
      ..strokeWidth = 0.5;

    final firstCol = ((0 - centro.dx) / escala).floor();
    final lastCol = ((size.width - centro.dx) / escala).ceil();

    final firstRow = ((0 - centro.dy) / escala).floor();
    final lastRow = ((size.height - centro.dy) / escala).ceil();

    for (int i = firstCol; i <= lastCol; i++) {
      final x = centro.dx + i * escala;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (int j = firstRow; j <= lastRow; j++) {
      final y = centro.dy + j * escala;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  void _drawLabel(
      Canvas canvas,
      String text,
      Offset position,
      TextStyle style,
      ) {
    final textSpan = TextSpan(text: text, style: style);
    final painter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    painter.layout();
    painter.paint(canvas, position);
  }

  void _drawAxes(Canvas canvas, Size size, Offset center) {
    final axisPaint = Paint()
      ..color = colorScheme.onSurface
      ..strokeWidth = 1.8;

    canvas.drawLine(
      Offset(0, center.dy),
      Offset(size.width, center.dy),
      axisPaint,
    );
    canvas.drawLine(
      Offset(center.dx, 0),
      Offset(center.dx, size.height),
      axisPaint,
    );

    canvas.drawLine(
      Offset(0, center.dy),
      Offset(size.width, center.dy),
      axisPaint,
    );
    canvas.drawLine(
      Offset(center.dx, 0),
      Offset(center.dx, size.height),
      axisPaint,
    );

    _drawLabel(
      canvas,
      'x',
      Offset(size.width - 14, center.dy - 20),
      TextStyle(color: colorScheme.onSurface, fontSize: 12),
    );
    _drawLabel(
      canvas,
      'y',
      Offset(center.dx - 12, 4),
      TextStyle(color: colorScheme.onSurface, fontSize: 12),
    );

    final firstCol = ((0 - center.dx) / escala).floor();
    final lastCol = ((size.width - center.dx) / escala).ceil();
    final firstRow = ((0 - center.dy) / escala).floor();
    final lastRow = ((size.height - center.dy) / escala).ceil();

    final labelStyle = TextStyle(color: colorScheme.onSurface, fontSize: 10);

    for (int i = firstCol; i <= lastCol; i++) {
      if (i == 0) continue;
      final x = center.dx + i * escala;
      _drawLabel(canvas, '$i', Offset(x - 5, center.dy + 4), labelStyle);
    }

    for (int j = firstRow; j <= lastRow; j++) {
      if (j == 0) continue;
      // j negativo en canvas = positivo en matemáticas
      final y = center.dy + j * escala;
      _drawLabel(canvas, '${-j}', Offset(center.dx + 4, y - 7), labelStyle);
    }
  }

  void _drawNumberLine(Canvas canvas, Size size, Offset center) {
    final axisPaint = Paint()
      ..color = colorScheme.onSurface
      ..strokeWidth = 1.8;

    final cy = size.height / 2;
    canvas.drawLine(Offset(0, cy), Offset(size.width, cy), axisPaint);

    final firstCol = ((0 - center.dx) / escala).floor();
    final lastCol = ((size.width - center.dx) / escala).ceil();
    final labelStyle = TextStyle(color: colorScheme.onSurface, fontSize: 11);
    final tickPaint = Paint()
      ..color = colorScheme.onSurface
      ..strokeWidth = 1;

    for (int i = firstCol; i <= lastCol; i++) {
      final x = center.dx + i * escala;

      canvas.drawLine(Offset(x, cy - 6), Offset(x, cy + 6), tickPaint);
      _drawLabel(canvas, '$i', Offset(x - 5, cy + 10), labelStyle);
    }
  }

  void _drawCargas(Canvas canvas, Offset centro){
    for(final carga in cargas){
      Paint colorPaint;
      if(carga.magnitud > 0){
        colorPaint = Paint()
            ..color = Colors.red
            ..style = PaintingStyle.fill;
      }
      else if(carga.magnitud < 0){
        colorPaint = Paint()
            ..color = Colors.blue
            ..style = PaintingStyle.fill;
      }
      else{
        colorPaint = Paint()
          ..color = colorScheme.onSurface
          ..style = PaintingStyle.fill;
      }
      final px = centro.dx + carga.pos.dx * escala;
      final py = centro.dy - carga.pos.dy * escala;
      canvas.drawCircle(
          Offset(px, py), 7,
          colorPaint
      );
      _drawLabel(canvas, carga.nombre, Offset(px + 10, py - 16), TextStyle(
        color: colorScheme.onSurface,
        fontSize: 12,
      ));
    }
  }

  @override
  bool shouldRepaint(SimuladorPainter old) =>
    old.esModo2D != esModo2D || old.escala != escala || old.indexSeleccionada != indexSeleccionada || old.origen != origen || old.cargas != cargas;
}
