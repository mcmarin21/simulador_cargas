import 'dart:math';
import 'package:flutter/material.dart';
import 'package:simulador_cargas/domain/carga.dart';
import 'package:simulador_cargas/domain/vector.dart';

class SimuladorPainter extends CustomPainter {
  final List<Carga> cargas;
  final Carga? cargaSeleccionada;
  final bool esModo2D;

  SimuladorPainter({
    required this.cargas,
    this.cargaSeleccionada,
    required this.esModo2D,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centroX = size.width / 2;
    final centroY = size.height / 2;

    final paintEjes = Paint()
      ..color = Colors.white30
      ..strokeWidth = 1.5;
    final paintRegla = Paint()
      ..color = Colors.white60
      ..strokeWidth = 2.0;

    // Escala del simulador: 1 unidad matemática = 40 píxeles en pantalla
    const double escalaRegla = 40.0;

    if (esModo2D) {
      // --- MODO 2D: Plano Cartesiano Completo ---
      canvas.drawLine(
        Offset(0, centroY),
        Offset(size.width, centroY),
        paintEjes,
      );
      canvas.drawLine(
        Offset(centroX, 0),
        Offset(centroX, size.height),
        paintEjes,
      );

      // Dibujar marcas numéricas del -10 al 10 en ambos ejes
      for (int i = -10; i <= 10; i++) {
        if (i == 0) continue; // El origen central (0,0) no requiere doble texto

        // MARCAS EN EJE X (Horizontal)
        double posX = centroX + (i * escalaRegla);
        canvas.drawLine(
          Offset(posX, centroY - 5),
          Offset(posX, centroY + 5),
          paintRegla,
        );

        final textSpanX = TextSpan(
          text: i.toString(),
          style: const TextStyle(color: Colors.white70, fontSize: 10),
        );
        final textPainterX = TextPainter(
          text: textSpanX,
          textDirection: TextDirection.ltr,
        )..layout();
        textPainterX.paint(
          canvas,
          Offset(posX - (textPainterX.width / 2), centroY + 8),
        );

        // MARCAS EN EJE Y (Vertical) - Positivo hacia arriba
        double posY = centroY - (i * escalaRegla);
        canvas.drawLine(
          Offset(centroX - 5, posY),
          Offset(centroX + 5, posY),
          paintRegla,
        );

        final textSpanY = TextSpan(
          text: i.toString(),
          style: const TextStyle(color: Colors.white70, fontSize: 10),
        );
        final textPainterY = TextPainter(
          text: textSpanY,
          textDirection: TextDirection.ltr,
        )..layout();
        // Colocamos el texto ligeramente a la izquierda del eje vertical
        textPainterY.paint(
          canvas,
          Offset(
            centroX - textPainterY.width - 8,
            posY - (textPainterY.height / 2),
          ),
        );
      }
    } else {
      // --- MODO 1D: Regla Lineal Horizontal ---
      canvas.drawLine(
        Offset(0, centroY),
        Offset(size.width, centroY),
        paintRegla,
      );

      for (int i = -10; i <= 10; i++) {
        double posX = centroX + (i * escalaRegla);
        canvas.drawLine(
          Offset(posX, centroY - 5),
          Offset(posX, centroY + 5),
          paintRegla,
        );

        final textSpan = TextSpan(
          text: i.toString(),
          style: const TextStyle(color: Colors.white70, fontSize: 10),
        );
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        )..layout();
        textPainter.paint(
          canvas,
          Offset(posX - (textPainter.width / 2), centroY + 10),
        );
      }
    }

    // Lógica para dibujar el vector de Fuerza Neta
    if (cargaSeleccionada != null && cargas.contains(cargaSeleccionada)) {
      double fNetaX = 0.0;
      double fNetaY = 0.0;

      for (var otra in cargas) {
        if (otra.id != cargaSeleccionada!.id) {
          Vector f = cargaSeleccionada!.calcularFuerza(otra);
          fNetaX += f.x;
          fNetaY += f.y;
        }
      }

      if (fNetaX.isFinite &&
          fNetaY.isFinite &&
          (fNetaX.abs() > 0.001 || fNetaY.abs() > 0.001)) {
        double mag = sqrt(fNetaX * fNetaX + fNetaY * fNetaY);
        double escalaFuerza = 60.0;

        double lx = (fNetaX / mag) * escalaFuerza;

        // SI ESTAMOS EN MODO 1D, LA FUERZA VISUAL VERTICAL DEBE SER CERO PARA NO INCLINAR EL VECTOR
        double ly = esModo2D ? (-(fNetaY / mag) * escalaFuerza) : 0.0;

        double origenX = centroX + (cargaSeleccionada!.pos.x * escalaRegla);

        // Ajustamos el origen de la flecha dependiendo del modo
        double coordenadaYOrigen = esModo2D ? cargaSeleccionada!.pos.y : 0.0;
        double origenY = centroY - (coordenadaYOrigen * escalaRegla);

        final pincelFuerzaNeta = Paint()
          ..color = Colors.greenAccent
          ..strokeWidth = 3.0;

        canvas.drawLine(
          Offset(origenX, origenY),
          Offset(origenX + lx, origenY + ly),
          pincelFuerzaNeta,
        );

        canvas.drawCircle(
          Offset(origenX + lx, origenY + ly),
          4.0,
          pincelFuerzaNeta..style = PaintingStyle.fill,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant SimuladorPainter oldDelegate) => true;
}
