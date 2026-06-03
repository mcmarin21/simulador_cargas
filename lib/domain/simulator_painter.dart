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
    super.repaint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final centro = Offset(
      size.width / 2 + origen.dx,
      size.height / 2 + origen.dy,
    );

    if (esModo2D) {
      _drawGrid(canvas, size, centro);
      _drawAxes(canvas, size, centro);
    } else {
      _drawNumberLine(canvas, size, centro);
    }

    _drawCargas(canvas, size, centro);

    if (indexSeleccionada >= 0 && indexSeleccionada < cargas.length) {
      _drawFuerzaResultante(canvas, size, centro, indexSeleccionada);
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

  void _drawLabel(Canvas canvas, String text, Offset position, TextStyle style) {
    final textSpan = TextSpan(text: text, style: style);
    final painter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    painter.layout();
    painter.paint(canvas, position);
  }

  void _drawAxes(Canvas canvas, Size size, Offset center) {
    final axisPaint = Paint()
      ..color = colorScheme.onSurface
      ..strokeWidth = 1.8;

    canvas.drawLine(Offset(0, center.dy), Offset(size.width, center.dy), axisPaint);
    canvas.drawLine(Offset(center.dx, 0), Offset(center.dx, size.height), axisPaint);

    _drawLabel(canvas, 'x', Offset(size.width - 14, center.dy - 20),
        TextStyle(color: colorScheme.onSurface, fontSize: 12));
    _drawLabel(canvas, 'y', Offset(center.dx - 12, 4),
        TextStyle(color: colorScheme.onSurface, fontSize: 12));

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

  void _drawCargas(Canvas canvas, Size size, Offset centro) {
    double py = size.height / 2;
    for (int i = 0; i < cargas.length; i++) {
      final carga = cargas[i];
      final isSelected = i == indexSeleccionada;

      final baseColor = carga.magnitud > 0
          ? Colors.red
          : carga.magnitud < 0
          ? Colors.blue
          : colorScheme.onSurface;

      final px = centro.dx + carga.pos.dx * escala;
      if (esModo2D) {
        py = centro.dy - carga.pos.dy * escala;
      }
      final center = Offset(px, py);

      if (isSelected) {
        final haloPaint = Paint()
          ..color = baseColor.withValues(alpha: 0.30)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(center, 16, haloPaint);
      }

      final fillPaint = Paint()
        ..color = carga.magnitud > 0
            ? Colors.red
            : carga.magnitud < 0
            ? Colors.blue
            : colorScheme.surface
        ..style = PaintingStyle.fill;

      final borderPaint = Paint()
        ..color = isSelected ? colorScheme.tertiary : baseColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = isSelected ? 3.5 : 2.5;

      canvas.drawCircle(center, 7, fillPaint);
      canvas.drawCircle(center, 7, borderPaint);

      _drawLabel(
        canvas,
        carga.nombre,
        Offset(px + 10, py - 16),
        TextStyle(
          color: colorScheme.onSurface,
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      );
    }
  }

  void _drawFuerzaResultante(
      Canvas canvas, Size size, Offset centro, int idx) {
    if (cargas.length < 2) return;

    final cargaOrigen = cargas[idx];

    Offset fuerzaR = Offset(0, 0);
    for (int i = 0; i < cargas.length; i++) {
      if (i == idx) continue;
      final f = cargaOrigen.calcularFuerza(cargas[i]);
      fuerzaR = fuerzaR + f;
    }

    final magnitudTotal = fuerzaR.distance;
    if (magnitudTotal == 0) return;

    final px = centro.dx + cargaOrigen.pos.dx * escala;
    final py = esModo2D
        ? centro.dy - cargaOrigen.pos.dy * escala
        : size.height / 2;
    final origin = Offset(px, py);

    // Longitud visual: escala logarítmica para que se vea bien con valores muy
    // dispares (mín 40 px, máx 120 px respecto al escala actual).
    const double minLen = 60.0;
    const double maxLen = 140.0;
    final logMag = log(magnitudTotal + 1);
    final visualLen = (minLen + (maxLen - minLen) * (logMag / (logMag + 10)))
        .clamp(minLen, maxLen);

    final double angle = esModo2D ? atan2(-fuerzaR.dy, fuerzaR.dx) : (fuerzaR.dx >= 0 ? 0.0 : pi);

    final tipX = origin.dx + visualLen * cos(angle);
    final tipY = origin.dy + visualLen * sin(angle);
    final tip = Offset(tipX, tipY);

    Color arrowColor = colorScheme.secondary;

    final linePaint = Paint()
      ..color = arrowColor
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    // Tronco de la flecha (deja espacio para la punta)
    const double headLen = 12.0;
    const double headHalf = 5.0;
    final shaftTip = Offset(
      origin.dx + (visualLen - headLen) * cos(angle),
      origin.dy + (visualLen - headLen) * sin(angle),
    );
    canvas.drawLine(origin, shaftTip, linePaint);

    // Punta de flecha (triángulo relleno)
    final perpX = -sin(angle);
    final perpY = cos(angle);
    final arrowPath = Path()
      ..moveTo(tip.dx, tip.dy)
      ..lineTo(shaftTip.dx + headHalf * perpX, shaftTip.dy + headHalf * perpY)
      ..lineTo(shaftTip.dx - headHalf * perpX, shaftTip.dy - headHalf * perpY)
      ..close();

    canvas.drawPath(arrowPath, Paint()..color = arrowColor);

    // Etiqueta con magnitud en notación científica
    final label = _formatCientifica(magnitudTotal);
    _drawLabel(
      canvas,
      'F = $label N',
      Offset(tip.dx + 6, tip.dy - 14),
      TextStyle(
        color: colorScheme.onSurface,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        shadows: [
          Shadow(
            color: colorScheme.surface.withValues(alpha: 0.85),
            blurRadius: 3,
            offset: const Offset(1, 1),
          )
        ],
      ),
    );
  }

  /// Convierte un número a notación científica compacta, e.g. "3.21×10⁵"
  String _formatCientifica(double valor) {
    if (valor == 0) return '0';
    final exp = log(valor) ~/ log(10);
    final mantisa = valor / pow(10, exp);
    const superscripts = ['⁰','¹','²','³','⁴','⁵','⁶','⁷','⁸','⁹'];

    String expStr = '';
    final absExp = exp.abs();
    if (absExp == 0) {
      expStr = '⁰';
    } else {
      for (final d in absExp.toString().split('')) {
        expStr += superscripts[int.parse(d)];
      }
    }
    if (exp < 0) expStr = '⁻$expStr';

    return '${mantisa.toStringAsFixed(2)}×10$expStr';
  }

  @override
  bool shouldRepaint(SimuladorPainter old) =>
      old.esModo2D != esModo2D ||
          old.escala != escala ||
          old.indexSeleccionada != indexSeleccionada ||
          old.origen != origen ||
          old.cargas != cargas;
}
