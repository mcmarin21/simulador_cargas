import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:simulador_cargas/domain/carga.dart';

class CargaDisplay extends StatelessWidget {
  final Carga carga;

  const CargaDisplay({
    required this.carga,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    IconData icono = Icons.circle_outlined;
    Color colorIcono = Colors.grey;

    if (carga.magnitud > 0) {
      icono = Icons.add_circle_outline_rounded;
      colorIcono = Colors.redAccent;
    } else if (carga.magnitud < 0) {
      icono = Icons.remove_circle_outline_rounded;
      colorIcono = Colors.blueAccent;
    }

    // Diseñamos la tarjeta básica que se repite
    Widget tarjetaCarga = Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icono, color: colorIcono, size: 28),
            const SizedBox(width: 8),
            Text(carga.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );

    // Hacemos que la tarjeta sea arrastrable
    return Draggable<Carga>(
      data: carga, // El objeto que va a viajar al soltarlo
      feedback: Material(
        color: Colors.transparent,
        child: Opacity(
          opacity: 0.7, // Se vuelve semi-transparente mientras lo arrastras
          child: tarjetaCarga,
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3, // Opaca el objeto original en la lista mientras se arrastra
        child: tarjetaCarga,
      ),
      child: tarjetaCarga, // Aspecto normal cuando está quieto en la lista
    );
  }
}