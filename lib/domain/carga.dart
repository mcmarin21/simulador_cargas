import 'dart:ui';

import 'dart:math';

class Carga {
  int id = 0;
  Offset pos;
  final String nombre;
  final double magnitud; // o int, según lo hayas definido
  final int prefijo;

  Carga(this.id, this.pos, this.magnitud, this.prefijo, this.nombre);


  Offset calcularFuerza(Carga otraCarga) {
    double r2 = (otraCarga.pos - pos).distanceSquared;
    if (r2 == 0) return Offset(0.0, 0.0);

    double kBase = 8.99;  
    double productoMagnitudes = magnitud.abs() * otraCarga.magnitud.abs();
    int sumaExponentes = 9 + prefijo + otraCarga.prefijo;
    double magnitudFuerza = (kBase * productoMagnitudes * pow(10, sumaExponentes)) / r2;

    double dx = otraCarga.pos.dx - pos.dx;
    double dy = otraCarga.pos.dy - pos.dy;
    double angulo = atan2(dy, dx);

    double fuerzaX = magnitudFuerza * cos(angulo);
    double fuerzaY = magnitudFuerza * sin(angulo);

    if (magnitud * otraCarga.magnitud > 0) {
      fuerzaX = -fuerzaX;
      fuerzaY = -fuerzaY;
    }
    return Offset(fuerzaX, fuerzaY);
  }

  Offset calcularCampoElectrico(Offset punto) {
    double r2 = (punto - pos).distanceSquared;

    if (r2 == 0) return Offset(0, 0);

    double kBase = 8.99;
    double q = magnitud.abs();
    int sumaExponentes = 9 + prefijo;

    double magnitudCampo = (kBase * q * pow(10, sumaExponentes)) / r2;

    double dx = punto.dx - pos.dx;
    double dy = punto.dy - pos.dy;
    double angulo = atan2(dy, dx);

    double campoX = magnitudCampo * cos(angulo);
    double campoY = magnitudCampo * sin(angulo);

    if (magnitud < 0) {
      campoX = -campoX;
      campoY = -campoY;
    }

    return Offset(campoX, campoY);
  }
}