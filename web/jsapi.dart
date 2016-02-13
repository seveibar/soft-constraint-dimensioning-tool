import 'design.dart';
import 'constraints.dart';
import 'geom.dart';
import 'dart:js' as js;

Design design;
init(Design _design){
  design = _design;
  js.context['addp'] = addPoint;
  js.context['d'] = addDistanceConstraint;
  js.context['h'] = addHorizontalConstraint;
  js.context['v'] = addVerticalConstraint;
  js.context['active'] = changeActivePoint;
}

void addPoint(num x, num y){
  design.points.add(new DPoint(x,y));
  design.activePoint = design.points.last;
}

void addDistanceConstraint(int a, int b, num distance, [num weight = 1]){
  design.constraints.add(new DistanceConstraint(design.points[a], design.points[b], distance, weight));
}

void addHorizontalConstraint(int a, int b, [num weight = 10]){
  design.constraints.add(new HorizontalConstraint(design.points[a], design.points[b], weight));
}

void addVerticalConstraint(int a, int b, [num weight = 10]){
  design.constraints.add(new VerticalConstraint(design.points[a], design.points[b], weight));
}

void changeActivePoint(int pointIndex){
  design.activePoint = design.points[pointIndex];
}
