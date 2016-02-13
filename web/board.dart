import 'dart:html';
import 'geom.dart';
import 'constraints.dart';

class Board{

  CanvasElement canvas;
  CanvasRenderingContext2D context;

  Board(){
    canvas = querySelector('canvas');
    context = canvas.getContext('2d');

    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight - 30;
  }

  void clear(){
    context.fillStyle = "#000";
    context.fillRect(0,0,canvas.width,canvas.height);
  }

  void drawPoints(List<DPoint> points){
    context.fillStyle = "#fff";
    for (int i = 0;i < points.length;i++){
      DPoint p = points[i];
      context.fillRect(p.x - 2, p.y - 2, 4, 4);
      context.font = "Arial 8px";
      context.fillText("P$i", p.x + 3, p.y - 3);
    }
  }

  void drawConstraints(List<Constraint> constraints){
    context.globalAlpha = .5;
    constraints.forEach((constraint){
      if (constraint is DistanceConstraint){
        DistanceConstraint dc = constraint as DistanceConstraint;
        context.strokeStyle = dc.score() < 5 ? "#fff" : "#f00";
        context.fillStyle = "#fff";
        context.beginPath();
        context.moveTo(dc.a.x, dc.a.y);
        context.lineTo(dc.b.x, dc.b.y);
        context.stroke();
        context.closePath();
        context.font = "Arial 8px";
        context.fillText("${dc.distance}", dc.midpoint().x + 5, dc.midpoint().y - 5);
      }
    });
    context.globalAlpha = 1;
  }
}
