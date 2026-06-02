import 'package:flutter/material.dart';
import 'package:simulador_cargas/domain/carga.dart';
import 'package:simulador_cargas/domain/vector.dart';
import 'package:simulador_cargas/ui/components/carga_display.dart';

class PanelCargas extends StatefulWidget{
  const PanelCargas({super.key});

  @override
  State<PanelCargas> createState() => _PanelCargasState();
}

class _PanelCargasState extends State<PanelCargas>{

  @override
  Widget build(BuildContext context) {

    var carga = Carga(Vector(0,0), 0, 0);

    return(
      Scaffold(
        appBar: AppBar(
          title: const Text('Simulador de cargas'),
        ),
        body: Column(
          children: [
            CargaDisplay(carga: carga),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => print("ola"),
          child: const Icon(Icons.add),
        ),
      )
    );
  }
}