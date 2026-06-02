import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:simulador_cargas/domain/carga.dart';

class CargaDisplay extends StatefulWidget{

  final Carga carga;

  const CargaDisplay({
    required this.carga,
    super.key,
  });

  @override
  State<CargaDisplay> createState() => _CargaDisplayState();
}

class _CargaDisplayState extends State<CargaDisplay>{

  @override
  Widget build(BuildContext context) {
    IconData icono;

    if(widget.carga.magnitud == 0){
      icono = Symbols.counter_0_rounded;
    }
    else if(widget.carga.magnitud > 0){
      icono = Symbols.add_circle_outline_rounded;
    }
    else{
      icono = Symbols.do_not_disturb_on_rounded;
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 12,
        children: [
          Icon(
            icono,
            size: 24,
            opticalSize: 24,
          ),
          Column(
            spacing: 4,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.carga.nombre),
              Text("${widget.carga.magnitud} x10^${widget.carga.prefijo}C"),
            ],
          )
        ],
      ),

    );
  }
}