import 'package:flutter/material.dart';
import 'package:simulador_cargas/domain/carga.dart';

class CargaDisplay extends StatefulWidget {
  final Carga carga;
  final Function(Carga)? onCargaDelete;
  final Function(Carga)? onCargaEdit;
  final bool mostrarAcciones;

  const CargaDisplay({
    required this.carga,
    required this.mostrarAcciones,
    this.onCargaDelete,
    this.onCargaEdit,
    super.key,
  });

  @override
  State createState() => _CargaDisplayState();
}

class _CargaDisplayState extends State<CargaDisplay> {

  bool _isHover = false;

  @override
  Widget build(BuildContext context) {


    IconData icono = Icons.circle_outlined;
    Color colorIcono = Colors.grey;

    if (widget.carga.magnitud > 0) {
      icono = Icons.add_circle_outline_rounded;
      colorIcono = Colors.redAccent;
    } else if (widget.carga.magnitud < 0) {
      icono = Icons.remove_circle_outline_rounded;
      colorIcono = Colors.blueAccent;
    }
    else if(widget.carga.magnitud == 0){
      icono = Icons.circle_outlined;
      colorIcono = Colors.grey;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHover = true),
      onExit: (_) => setState(() => _isHover = false),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        margin: EdgeInsetsGeometry.symmetric(vertical: 2, horizontal: 0),
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
                      widget.carga.nombre,
                      style: TextTheme.of(context).titleMedium,
                    ),

                    Text(
                      "Valor: ${widget.carga.magnitud} × 10^${widget.carga.prefijo} C",
                      style: TextTheme.of(context).bodyMedium,
                    ),
                    const SizedBox(height: 2),

                    Text(
                      "Pos: (${widget.carga.pos.x.toStringAsFixed(0)}, ${widget.carga.pos.y.toStringAsFixed(0)})",
                      style: TextTheme.of(context).bodySmall,
                    ),
                  ],
                ),
              ),

              if(widget.mostrarAcciones) AnimatedOpacity(
                opacity: _isHover ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 75),
                curve: Cubic(0.37, 0.00, 0.63, 1.00),
                child: IgnorePointer(
                  ignoring: !_isHover, // evita clicks cuando está oculto
                  child: Row(
                    spacing: 4,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () => widget.onCargaEdit,
                        icon: Icon(
                          Icons.edit,
                        ),
                        iconSize: 24,
                      ),
                      IconButton(
                        onPressed: () => widget.onCargaDelete,
                        icon: Icon(
                          Icons.delete,
                        ),
                        iconSize: 24,
                        color: Theme.of(context).colorScheme.error,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
