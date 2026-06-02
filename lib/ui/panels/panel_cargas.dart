import 'package:flutter/material.dart';

class PanelCargas extends StatefulWidget{
  const PanelCargas({super.key});

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
        body: Center(child: Text('Hola')),
        floatingActionButton: FloatingActionButton(
          onPressed: () => print("ola"),
          child: const Icon(Icons.add),
        ),
      )
    );
  }
}