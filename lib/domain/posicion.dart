import 'dart:math';

class Posicion {
  double posX = 0;
  double posY = 0;

  Posicion(this.posX, this.posY);

  double obtenerDistancia(Posicion pos1, Posicion pos2){
    return sqrt(pow(pos1.posX - pos2.posX, 2) + pow(pos1.posY - pos2.posY, 2));
  }

  Posicion operator +(Posicion o) => Posicion(posX + o.posX, posY + o.posY);
  Posicion operator -(Posicion o) => Posicion(posX - o.posX, posY - o.posY);

  @override
  bool operator ==(Object other) =>
      other is Posicion && posX == other.posX && posY == other.posY;

  @override
  int get hashCode => Object.hash(posX, posY);
}