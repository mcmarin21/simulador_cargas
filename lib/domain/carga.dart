import 'package:simulador_cargas/domain/vector.dart';
import 'dart:math';

class Carga {
  Vector pos;
  double magnitud = 0;
  int prefijo = 0;

  Carga(this.pos, this.magnitud, this.prefijo);


  Vector calcularFuerza(Carga otraCarga) {
    double r = this.pos.obtenerDistancia(this.pos, otraCarga.pos);
    double r2 = r * r;
    if (r == 0) return Vector(0, 0);

    double kBase = 8.99;  
    double productoMagnitudes = this.magnitud.abs() * otraCarga.magnitud.abs();
    int sumaExponentes = 9 + this.prefijo + otraCarga.prefijo;
    double magnitudFuerza = (kBase * productoMagnitudes * pow(10, sumaExponentes)) / r2;

    double dx = otraCarga.pos.x - this.pos.x;
    double dy = otraCarga.pos.y - this.pos.y;
    double angulo = atan2(dy, dx);

    double fuerzaX = magnitudFuerza * cos(angulo);
    double fuerzaY = magnitudFuerza * sin(angulo);

    if (this.magnitud * otraCarga.magnitud > 0) {
      fuerzaX = -fuerzaX;
      fuerzaY = -fuerzaY;
    }
    return Vector(fuerzaX, fuerzaY);
  }

  Vector calcularCampoElectrico(Vector punto) {
    double r = this.pos.obtenerDistancia(this.pos, punto);
    double r2 = r * r;

    if (r == 0) return Vector(0, 0);

    double kBase = 8.99;
    double q = this.magnitud.abs();
    int sumaExponentes = 9 + this.prefijo;

    double magnitudCampo = (kBase * q * pow(10, sumaExponentes)) / r2;

    double dx = punto.x - this.pos.x;
    double dy = punto.y - this.pos.y;
    double angulo = atan2(dy, dx);

    double campoX = magnitudCampo * cos(angulo);
    double campoY = magnitudCampo * sin(angulo);

    if (this.magnitud < 0) {
      campoX = -campoX;
      campoY = -campoY;
    }

    return Vector(campoX, campoY);
  }
}