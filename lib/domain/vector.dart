import 'dart:math';

class Vector {
  double x = 0;
  double y = 0;

  Vector(this.x, this.y);

  double obtenerDistancia(Vector pos1, Vector pos2){
    return sqrt(pow(pos1.x - pos2.x, 2) + pow(pos1.y - pos2.y, 2));
  }

  Vector operator +(Vector o) => Vector(x + o.x, y + o.y);
  Vector operator -(Vector o) => Vector(x - o.x, y - o.y);

  @override
  bool operator ==(Object other) =>
      other is Vector && x == other.x && y == other.y;

  @override
  int get hashCode => Object.hash(x, y);
}