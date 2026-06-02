import 'package:flutter/material.dart';
import 'package:simulador_cargas/domain/carga.dart';
import 'package:simulador_cargas/domain/vector.dart';
import 'package:simulador_cargas/ui/components/carga_display.dart';

class PanelCargas extends StatefulWidget {
  final List<Carga> cargas;
  final ValueChanged<Carga> onCargaAgregada;

  const PanelCargas({
    required this.cargas,
    required this.onCargaAgregada,
    super.key,
  });

  @override
  State<PanelCargas> createState() => _PanelCargasState();
}

class _PanelCargasState extends State<PanelCargas> {
  void _mostrarVentanaConfiguracion() {
    final nombreCtrl = TextEditingController(text: "Q${widget.cargas.length + 1}");
    final magnitudCtrl = TextEditingController(text: "1.0");
    final prefijoCtrl = TextEditingController(text: "-6");
    
    // 1. Nuevos controladores para las posiciones
    final posXCtrl = TextEditingController(text: "0.0");
    final posYCtrl = TextEditingController(text: "0.0");

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Agregar Carga con Posición"),
          // Usamos SingleChildScrollView por si el teclado tapa la pantalla
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nombreCtrl,
                  decoration: const InputDecoration(labelText: "Nombre de la carga"),
                ),
                TextField(
                  controller: magnitudCtrl,
                  keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                  decoration: const InputDecoration(labelText: "Magnitud (ej. 5 o -3)"),
                ),
                TextField(
                  controller: prefijoCtrl,
                  keyboardType: const TextInputType.numberWithOptions(signed: true),
                  decoration: const InputDecoration(labelText: "Exponente x10^ (ej. -6)"),
                ),
                const Divider(height: 30),
                const Text("Coordenadas en el Plano", style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: posXCtrl,
                        keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                        decoration: const InputDecoration(labelText: "Posición X"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: posYCtrl,
                        keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                        decoration: const InputDecoration(labelText: "Posición Y"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                final double mag = double.tryParse(magnitudCtrl.text) ?? 1.0;
                final int pref = int.tryParse(prefijoCtrl.text) ?? -6;
                
                // 2. Leemos las coordenadas que ingresó el usuario
                final double pX = double.tryParse(posXCtrl.text) ?? 0.0;
                final double pY = double.tryParse(posYCtrl.text) ?? 0.0;
                
                final int idUnico = DateTime.now().microsecondsSinceEpoch;

                final nuevaCarga = Carga(
                  idUnico,
                  Vector(pX, pY), // 3. ¡Se asigna directamente a la matemática!
                  mag,
                  pref,
                  nombreCtrl.text,
                );

                widget.onCargaAgregada(nuevaCarga);
                Navigator.pop(context);
              },
              child: const Text("Colocar en Plano"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú de Cargas'),
      ),
      body: widget.cargas.isEmpty
          ? const Center(child: Text("No hay cargas agregadas"))
          : ListView.builder(
              itemCount: widget.cargas.length,
              itemBuilder: (context, index) {
                return CargaDisplay(carga: widget.cargas[index]);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarVentanaConfiguracion,
        child: const Icon(Icons.add),
      ),
    );
  }
}