import 'package:flutter/material.dart';
import 'package:simulador_cargas/domain/carga.dart';
import 'package:simulador_cargas/ui/components/carga_display.dart';

class PanelCargas extends StatefulWidget {
  final List<Carga> cargas;
  final ValueChanged<Carga> onCargaAgregada;
  final ValueChanged<Carga> onCargaEliminada;
  final ValueChanged<Carga> onCargaEditada;

  const PanelCargas({
    required this.cargas,
    required this.onCargaAgregada,
    required this.onCargaEliminada,
    required this.onCargaEditada,
    super.key,
  });

  @override
  State<PanelCargas> createState() => _PanelCargasState();
}

class _PanelCargasState extends State<PanelCargas> {

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _mostrarVentanaConfiguracion({Carga? cargaAEditar}) {
    final bool esEdicion = cargaAEditar != null;

    final nombreCtrl = TextEditingController(text: esEdicion ? cargaAEditar.nombre : "Q${widget.cargas.length + 1}");
    final magnitudCtrl = TextEditingController(text: esEdicion ? cargaAEditar.magnitud.toString() : "1.0");
    final prefijoCtrl = TextEditingController(text: esEdicion ? cargaAEditar.prefijo.toString() : "-6");
    final posXCtrl = TextEditingController(text: esEdicion ? cargaAEditar.pos.dx.toString() : "0.0");
    final posYCtrl = TextEditingController(text: esEdicion ? cargaAEditar.pos.dy.toString() : "0.0");

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(esEdicion ? "Editar Carga" : "Agregar Carga con Posición"),
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
                final double pX = double.tryParse(posXCtrl.text) ?? 0.0;
                final double pY = double.tryParse(posYCtrl.text) ?? 0.0;

                if (esEdicion) {
                  final cargaEditada = Carga(
                    cargaAEditar.id,
                    Offset(pX, pY),
                    mag,
                    pref,
                    nombreCtrl.text,
                  );
                  widget.onCargaEditada(cargaEditada);
                } else {
                  final nuevaCarga = Carga(
                    DateTime.now().microsecondsSinceEpoch,
                    Offset(pX, pY),
                    mag,
                    pref,
                    nombreCtrl.text,
                  );
                  widget.onCargaAgregada(nuevaCarga);
                }

                Navigator.pop(context);
              },
              child: Text(esEdicion ? "Guardar Cambios" : "Colocar en Plano"),
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
        title: const Text('Simulador de cargas'),
      ),
      body: Scrollbar(
        controller: _scrollController,
        child: Padding(
          padding: EdgeInsetsGeometry.fromLTRB(12, 0, 20, 0),
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(32), bottom: Radius.zero),
            clipBehavior: Clip.antiAlias,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: widget.cargas.isEmpty ? 1 : widget.cargas.length,
                itemBuilder: (context, index) {
                  if (widget.cargas.isEmpty) {
                    return const Center(child: Text("No hay cargas agregadas"));
                  }
                  return CargaDisplay(
                      carga: widget.cargas[index],
                      mostrarAcciones: true,
                      onCargaDelete: (carga) {
                        widget.onCargaEliminada(carga);
                      },
                      onCargaEdit: (carga) => _mostrarVentanaConfiguracion(cargaAEditar: carga)
                  );
                },
              ),
            ),
          ),
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarVentanaConfiguracion(),
        child: const Icon(Icons.add),
      ),
    );
  }
}