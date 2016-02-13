import 'geom.dart';
import 'constraints.dart';

class Design{
  List<DPoint> points;
  List<Constraint> constraints;
  DPoint activePoint;
  Design(this.points, this.constraints, this.activePoint);
}
