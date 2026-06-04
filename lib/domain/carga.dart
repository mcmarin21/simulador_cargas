import 'dart:ui';

import 'dart:math';

class Carga {
  int id = 0;
  Offset pos;
  final String nombre;
  final double magnitud; // o int, según lo hayas definido
  final int prefijo;

  Carga(this.id, this.pos, this.magnitud, this.prefijo, this.nombre);


  Offset calcularFuerza(Carga otraCarga, bool esModo2D) {
    Offset vectorPos = esModo2D ? otraCarga.pos - pos : Offset(otraCarga.pos.dx - pos.dx, 0);
    double r2 = vectorPos.distanceSquared;
    if (r2 == 0) return Offset(0.0, 0.0);

    double kBase = 8.99;  
    double productoMagnitudes = magnitud.abs() * otraCarga.magnitud.abs();
    int sumaExponentes = 9 + prefijo + otraCarga.prefijo;
    double magnitudFuerza = (kBase * productoMagnitudes * pow(10, sumaExponentes)) / r2;

    Offset direccionUnitaria = vectorPos / vectorPos.distance;
    Offset fuerza =  direccionUnitaria * magnitudFuerza;

    if (magnitud * otraCarga.magnitud > 0){
      fuerza = -fuerza;
    }

    return fuerza;
  }

  Offset calcularCampoElectrico(Offset punto, bool esModo2D) {
    Offset vectorPos = esModo2D ? punto - pos : Offset(punto.dx - pos.dx, 0);
    double r2 = vectorPos.distanceSquared;

    if (r2 == 0) return Offset.zero;

    double kBase = 8.99;
    int sumaExponentes = 9 + prefijo;

    double magnitudCampo = (kBase * magnitud.abs() * pow(10, sumaExponentes)) / r2;

    Offset direccionUnitaria = vectorPos / vectorPos.distance;
    Offset campo = direccionUnitaria * magnitudCampo;

    if (magnitud < 0) {
      campo = -campo;
    }

    return campo;
  }

  @override
  int get hashCode => Object.hash(id, pos, nombre, magnitud, prefijo);

  @override
  bool operator ==(Object other) =>
      other is Carga && runtimeType == other.runtimeType && id == other.id;
}