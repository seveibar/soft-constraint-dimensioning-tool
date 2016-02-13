import 'dart:math';
import 'geom.dart';

class Constraint{
  num score() => 0;
}

class DistanceConstraint implements Constraint{
  DPoint a,b;
  num distance, weight;
  DistanceConstraint(this.a, this.b, this.distance, [this.weight=1]);
  DPoint midpoint() => new DPoint((a.x + b.x)/2, (a.y + b.y)/2);
  num score() => pow(a.dist(b) - distance,2) * weight;
}

class HorizontalConstraint implements Constraint{
  DPoint a,b;
  num weight;
  HorizontalConstraint(this.a, this.b, [this.weight=10]);
  num score() => pow(a.y - b.y, 2) * weight;
}

class VerticalConstraint implements Constraint{
  DPoint a,b;
  num weight;
  VerticalConstraint(this.a, this.b, [this.weight=10]);
  num score() => pow(a.x - b.x, 2) * weight;
}

class AnchorConstraint{
  DPoint a;
  num x,y, weight;
  AnchorConstraint(this.a, this.x, this.y, [this.weight = 100]);
  num score() => pow(sqrt(pow(a.x - x,2) + pow(a.y - y,2)),2) * weight;
}
