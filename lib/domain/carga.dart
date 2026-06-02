import 'package:simulador_cargas/domain/posicion.dart';

class Carga {
  Posicion pos;
  double magnitud = 0;
  int? prefijo;

  Carga(this.pos, this.magnitud, [this.prefijo]);

}