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

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Función encargada de desplegar la ventana emergente
  void _mostrarVentanaConfiguracion(BuildContext context) {
    final nombreController = TextEditingController(text: "Carga Q1");
    final magnitudController = TextEditingController(text: "5.0");
    final prefijoController = TextEditingController(text: "-6");

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {

            // 1. Parseas el texto que el usuario escribe
            final double? magnitudInput = double.tryParse(magnitudController.text);
            final int? prefijoInput = int.tryParse(prefijoController.text);

            // 2. Evaluamos el signo para mostrar información visual dinámica en el formulario
            double magnitudActual = magnitudInput ?? 0.0;

            String tipoDeCarga;
            Color colorEstado;
            IconData iconoEstado;

            if (magnitudActual == 0) {
              tipoDeCarga = "Carga Neutra";
              colorEstado = Colors.grey;
              iconoEstado = Icons.circle_outlined;
            } else if (magnitudActual > 0) {
              tipoDeCarga = "Carga Positiva (Protón / Fuente)";
              colorEstado = Colors.redAccent;
              iconoEstado = Icons.add_circle_rounded;
            } else {
              tipoDeCarga = "Carga Negativa (Electrón / Sumidero)";
              colorEstado = Colors.blueAccent;
              iconoEstado = Icons.remove_circle_rounded;
            }

            // 3. Creamos la carga de prueba
            final cargaNuevaPreview = Carga(
              0,
              Vector(0, 0),
              magnitudActual,
              prefijoInput ?? 0,
              nombreController.text.isEmpty ? "Carga" : nombreController.text,
            );

            return AlertDialog(
              title: const Text('Configurar Nueva Carga'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nombreController,
                      decoration: const InputDecoration(labelText: 'Nombre de la carga'),
                      onChanged: (val) => setDialogState(() {}),
                    ),
                    const SizedBox(height: 12),

                    // INPUT DE MAGNITUD: El truco está aquí
                    TextField(
                      controller: magnitudController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true), // Habilita el signo '-' en el teclado móvil
                      decoration: InputDecoration(
                        labelText: 'Magnitud',
                        hintText: 'Ej: 5.0 o -5.0',
                        helperText: 'Coloca un menos (-) para hacerla negativa',
                        helperStyle: TextStyle(color: colorEstado, fontWeight: FontWeight.bold),
                      ),
                      onChanged: (val) {
                        // Al escribir, forzamos a que el diálogo vuelva a leer el número y cambie los colores
                        setDialogState(() {});
                      },
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: prefijoController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Prefijo Exponente (int)'),
                      onChanged: (val) => setDialogState(() {}),
                    ),

                    const SizedBox(height: 20),

                    // INDICADOR DINÁMICO EN EL FORMULARIO
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: colorEstado.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: colorEstado.withOpacity(0.5)),
                      ),
                      child: Row(
                        spacing: 8,
                        children: [
                          Icon(iconoEstado, color: colorEstado),
                          Text(
                            tipoDeCarga,
                            style: TextStyle(color: colorEstado, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    const Text(
                      'Vista previa en tiempo real:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.blueGrey),
                    ),
                    const SizedBox(height: 8),

                    // Tu CargaDisplay que ya tiene la lógica de cambiar de color sola
                    CargaDisplay(carga: cargaNuevaPreview),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    nombreController.dispose();
                    magnitudController.dispose();
                    prefijoController.dispose();
                    Navigator.pop(context);
                  },
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (magnitudInput == null || prefijoInput == null) return;

                    final cargaDefinitiva = Carga(
                      widget.cargas.length + 1,
                      Vector(0, 0),
                      magnitudActual,
                      prefijoInput,
                      nombreController.text.isEmpty ? "Carga" : nombreController.text,
                    );

                    nombreController.dispose();
                    magnitudController.dispose();
                    prefijoController.dispose();

                    Navigator.pop(context);
                    widget.onCargaAgregada(cargaDefinitiva);
                  },
                  child: const Text('Agregar'),
                ),
              ],
            );
          },
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
          padding: EdgeInsetsGeometry.fromLTRB(24, 32, 24, 0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: widget.cargas.isEmpty ? 1 : widget.cargas.length,
                itemBuilder: (context, index) {
                  if (widget.cargas.isEmpty) {
                    return const Center(child: Text("No hay cargas agregadas"));
                  }
                  return CargaDisplay(carga: widget.cargas[index]);
                },
              ),
            ),
          ),
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarVentanaConfiguracion(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}