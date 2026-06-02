import 'package:flutter/material.dart';
import 'package:simulador_cargas/domain/carga.dart';

class CargaDisplay extends StatelessWidget {
  final Carga carga;

  const CargaDisplay({required this.carga, super.key});

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
    else if(carga.magnitud == 0){
      icono = Icons.circle_outlined;
      colorIcono = Colors.grey;
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsetsGeometry.symmetric(vertical: 6, horizontal: 0),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Icon(icono, color: colorIcono, size: 32),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    carga.nombre,
                    style: TextTheme.of(context).titleMedium,
                  ),

                  Text(
                    "Valor: ${carga.magnitud} × 10^${carga.prefijo} C",
                    style: TextTheme.of(context).bodyMedium,
                  ),
                  const SizedBox(height: 2),

                  Text(
                    "Pos: (${carga.pos.x.toStringAsFixed(0)}, ${carga.pos.y.toStringAsFixed(0)})",
                    style: TextTheme.of(context).bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
