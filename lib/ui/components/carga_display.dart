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
      tipoTexto = "Positiva";
    } else if (carga.magnitud < 0) {
      icono = Icons.remove_circle_outline_rounded;
      colorTematico = Colors.blueAccent;
      tipoTexto = "Negativa";
    }

    // 2. Evaluamos si ya está en el plano o sigue en la barra (asumiendo 0,0 como origen del panel)
    bool estaEnPlano = (carga.pos.x != 0 || carga.pos.y != 0);

    // 3. Rediseñamos la tarjeta con todos sus metadatos físicos internos
    Widget tarjetaCarga = Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      elevation: estaEnPlano
          ? 1
          : 4, // Menor relieve visual si ya está en el plano
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        // Si está en el plano, le encendemos un borde reactivo del color de la carga
        side: BorderSide(
          color: estaEnPlano
              ? colorTematico.withOpacity(0.6)
              : Colors.transparent,
          width: estaEnPlano ? 2 : 0,
        ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        carga.nombre,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // Pequeño indicador del estado de arrastre
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: estaEnPlano
                              ? Colors.green.withOpacity(0.1)
                              : Colors.amber.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          estaEnPlano ? "En plano" : "En barra",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: estaEnPlano
                                ? Colors.green
                                : Colors.amber[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Renglón medio: Valor con notación científica estilizada (Ej: 5.0 × 10^-6 C)
                  Text(
                    "Valor: ${carga.magnitud} × 10^${carga.prefijo} C",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),

                  // Renglón inferior: Coordenadas físicas reales y tipo de carga
                  Text(
                    "Tipo: $tipoTexto | Pos: (${carga.pos.x.toStringAsFixed(0)}, ${carga.pos.y.toStringAsFixed(0)})",
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    // 4. Mantenemos tu excelente estructura del Draggable intacta
    return Draggable<Carga>(
      data: carga, // El objeto viaja al soltarlo en el DragTarget
      feedback: Material(
        color: Colors.transparent,
        child: Opacity(
          opacity: 0.75, // Semi-transparente al vuelo
          child: SizedBox(
            width:
                250, // Forzamos un ancho controlado para que no colapse al arrastrar
            child: tarjetaCarga,
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity:
            0.3, // Opaca el objeto en la barra lateral mientras se arrastra
        child: tarjetaCarga,
      ),
      child: tarjetaCarga, // Aspecto normal en la lista
    );
  }
}
