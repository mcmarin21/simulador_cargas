import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:simulador_cargas/domain/carga.dart';

class CargaDisplay extends StatelessWidget {
  final Carga carga;

  const CargaDisplay({required this.carga, super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Identificamos los datos visuales dinámicos según el signo matemático de la magnitud
    IconData icono = Icons.circle_outlined;
    Color colorTematico = Colors.grey;
    String tipoTexto = "Neutra";

    if (carga.magnitud > 0) {
      icono = Icons.add_circle_outline_rounded;
      colorTematico = Colors.redAccent;
    } else if (carga.magnitud < 0) {
      icono = Icons.remove_circle_outline_rounded;
      colorTematico = Colors.blueAccent;
    }
    else if(carga.magnitud == 0){
      icono = Icons.circle_outlined;
      colorTematico = Colors.grey;
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // El ícono representativo de física con su color temático
            Icon(icono, color: colorTematico, size: 32),
            const SizedBox(width: 12),

            // Columna informativa con la info estructurada de la carga
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Renglón superior: Nombre + Chip de Estado dinámico
                  Text(
                    carga.nombre,
                    style: TextTheme.of(context).titleMedium,
                  ),

                  // Renglón medio: Valor con notación científica estilizada (Ej: 5.0 × 10^-6 C)
                  Text(
                    "Valor: ${carga.magnitud} × 10^${carga.prefijo} C",
                    style: TextTheme.of(context).bodyMedium,
                  ),
                  const SizedBox(height: 2),

                  // Renglón inferior: Coordenadas físicas reales y tipo de carga
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
