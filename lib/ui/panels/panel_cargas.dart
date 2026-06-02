import 'package:flutter/material.dart';
import 'package:simulador_cargas/domain/carga.dart';
//import 'package:simulador_cargas/domain/vector.dart';
import 'package:simulador_cargas/ui/components/carga_display.dart';

class PanelCargas extends StatefulWidget{
  final List<Carga> cargas;
  final VoidCallback onFABPressed;
  const PanelCargas({
    required this.cargas,
    required this.onFABPressed,
    super.key
  });

  @override
  State<PanelCargas> createState() => _PanelCargasState();
}

class _PanelCargasState extends State<PanelCargas>{

  @override
  Widget build(BuildContext context) {

    return(
      Scaffold(
        appBar: AppBar(
          title: const Text('Simulador de cargas'),
        ),
        body: ListView.builder(
          itemCount: widget.cargas.isEmpty ? 1 : widget.cargas.length,
          itemBuilder: (context, index) {
            if (widget.cargas.isEmpty) {
              return Center(child: Text("No hay cargas agregadas"));
            }
            return CargaDisplay(carga: widget.cargas[index]);
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: widget.onFABPressed,
          child: const Icon(Icons.add),
        ),
      )
    );
  }
}