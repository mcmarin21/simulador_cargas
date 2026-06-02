import 'package:simulador_cargas/domain/vector.dart';

class Carga {
  Vector pos;
  double magnitud = 0;
  int? prefijo;

  Carga(this.pos, this.magnitud, [this.prefijo]);

}