import 'package:flutter/material.dart';
import 'package:simulador_cargas/domain/carga.dart';
import 'package:simulador_cargas/domain/vector.dart';
import 'package:simulador_cargas/ui/components/carga_display.dart';

class PanelCargas extends StatefulWidget {
  final List<Carga> cargas;
  final ValueChanged<Carga> onCargaAgregada; // <-- Cambiamos esto

  const PanelCargas({
    required this.cargas,
    required this.onCargaAgregada, // <-- Cambiamos esto
    super.key,
  });

  @override
  State<PanelCargas> createState() => _PanelCargasState();
}

class _PanelCargasState extends State<PanelCargas> {

  // Función encargada de desplegar la ventana emergente
  void _mostrarVentanaConfiguracion(BuildContext context) {
  // 1. Creamos los controladores para capturar el texto de los inputs
  final nombreController = TextEditingController(text: "Carga Q1");
  final magnitudController = TextEditingController(text: "5.0");
  final prefijoController = TextEditingController(text: "-6");

  showDialog(
    context: context,
    builder: (BuildContext context) {
      // Usamos StatefulBuilder para que la vista previa cambie en tiempo real al escribir
      return StatefulBuilder(
        builder: (context, setDialogState) {
          
          // 2. Parseas con seguridad los valores que el usuario va escribiendo
          final double? magnitudInput = double.tryParse(magnitudController.text);
          final int? prefijoInput = int.tryParse(prefijoController.text);

          // 3. Creamos la carga temporal usando lo que haya en los inputs (o valores por defecto si están vacíos)
          final cargaNuevaPreview = Carga(
            0,
            Vector(0, 0),
            magnitudInput ?? 0.0,
            prefijoInput ?? 0,
            nombreController.text.isEmpty ? "Sin nombre" : nombreController.text,
          );

          return AlertDialog(
            title: const Text('Configurar Nueva Carga'),
            content: SingleChildScrollView( // Evita que se corte la pantalla si se abre el teclado
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- FORMULARIO DE CONFIGURACIÓN ---
                  TextField(
                    controller: nombreController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre de la carga',
                      hintText: 'Ej: Q1, Carga Central',
                    ),
                    onChanged: (val) => setDialogState(() {}), // Refresca la vista previa
                  ),
                  const SizedBox(height: 12),
                  
                  TextField(
                    controller: magnitudController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Magnitud (double)',
                      hintText: 'Ej: 5.0 o -3.5',
                    ),
                    onChanged: (val) => setDialogState(() {}),
                  ),
                  const SizedBox(height: 12),
                  
                  TextField(
                    controller: prefijoController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Prefijo Exponente (int)',
                      hintText: 'Ej: -6 para micro (x10^-6)',
                    ),
                    onChanged: (val) => setDialogState(() {}),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // --- SECCIÓN DE VISTA PREVIA ---
                  const Text(
                    'Vista previa en tiempo real:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.blueGrey),
                  ),
                  const SizedBox(height: 8),
                  
                  // Tu widget maravilloso reaccionando a los cambios
                  CargaDisplay(carga: cargaNuevaPreview),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // Limpieza de controladores al cancelar
                  nombreController.dispose();
                  magnitudController.dispose();
                  prefijoController.dispose();
                  Navigator.pop(context);
                },
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
  onPressed: () {
  final double? magnitudInput = double.tryParse(magnitudController.text);
  final int? prefijoInput = int.tryParse(prefijoController.text);

  final cargaDefinitiva = Carga(
    widget.cargas.length + 1, // ID automático
    Vector(0, 0),             // Posición
    magnitudInput ?? 0.0,     // Magnitud real
    prefijoInput ?? 0,        // Prefijo real
    nombreController.text.isEmpty ? "Carga" : nombreController.text,
  );

  nombreController.dispose();
  magnitudController.dispose();
  prefijoController.dispose();

  Navigator.pop(context); // Cierra el diálogo
  widget.onCargaAgregada(cargaDefinitiva); // <-- Mandamos la carga al main.dart
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
      body: ListView.builder(
        itemCount: widget.cargas.isEmpty ? 1 : widget.cargas.length,
        itemBuilder: (context, index) {
          if (widget.cargas.isEmpty) {
            return const Center(child: Text("No hay cargas agregadas"));
          }
          return CargaDisplay(carga: widget.cargas[index]); // El llamado original en la lista [cite: 51]
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarVentanaConfiguracion(context), // Llama a la ventana flotante
        child: const Icon(Icons.add),
      ),
    );
  }
}