import 'dart:html';
import 'dart:math';
import 'dart:async';

import 'geom.dart';
import 'constraints.dart';
import 'board.dart';
import 'jsapi.dart' as jsapi;
import 'design.dart';


List<DPoint> points;
Board board;
Design design;
List<Constraint> constraints;
String actionMode = "move-point";
int actionStage = 0;

Map<String, List<String>> actionTips = {
  "move-point": ["Select Point", "Select New Location"],
  "add-points": ["Select New Point Location"],
  "activate-point": ["Select Point to Activate"],
  "dimension": ["Select Point 1", "Select Point 2"],
  "horizontal": ["Select Point 1", "Select Point 2"],
  "vertical": ["Select Point 1", "Select Point 2"]
};

void main(){

  board = new Board();

  points = [new DPoint(50,50),
            new DPoint(350,50),
            new DPoint(350,350),
            new DPoint(150,250)];

  constraints = [
    new DistanceConstraint(points[0], points[1], 300, 1),
    new DistanceConstraint(points[1], points[2], 300, 1),
    new DistanceConstraint(points[2], points[3], 300, 1),
    new DistanceConstraint(points[0], points[3], 300, 1),
  ];

  design = new Design(points, constraints, points[3]);
  jsapi.init(design);

  new Timer.periodic(new Duration(milliseconds: 16), (timer) {
    points.forEach((point){
      point.deviate((p){
        return constraints.map((constraint) => constraint.score())
                          .reduce((a,b) => a + b);
      }, radius: 1);
    });
    // design.activePoint.deviate((p){
    //   return constraints.map((constraint) => constraint.score())
    //                     .reduce((a,b) => a + b);
    // }, radius: 5);
    board.clear();
    board.drawConstraints(constraints);
    board.drawPoints(points);
    querySelector("#actionbox").innerHtml = actionTips[actionMode][actionStage];
  });

  // --------------------------------------------------------
  // ACTION MODE HANDLERS
  // --------------------------------------------------------

  board.canvas.addEventListener("click", (MouseEvent event){
    // points[design.activePoint].x = event.client.x;
    // points[design.activePoint].y = event.client.y;
    num mx = event.client.x, my = event.client.y;
    DPoint mouse = new DPoint(mx, my);
    if (actionMode == "add-points"){
      // ACTION MODE ADD POINTS
      jsapi.addPoint(mx, my);

    }else if (actionMode == "dimension"){
      // ACTION MODE DIMENSION
      if (actionStage == 0){
        design.activePoint = mouse.nearest(points);
      }else if (actionStage == 1){
        InputElement dimSizeElm = querySelector("#dimension-size");
        constraints.add(
          new DistanceConstraint(
            design.activePoint,
            mouse.nearest(points),
            num.parse(dimSizeElm.value)
          ));
      }
      actionStage = (actionStage + 1)%2;

    }else if (actionMode == 'horizontal'){
      // ACTION MODE HORIZONTAL
      if (actionStage == 0){
        design.activePoint = mouse.nearest(points);
      }else if (actionStage == 1){
        constraints.add(
          new HorizontalConstraint( design.activePoint, mouse.nearest(points)));
      }
      actionStage = (actionStage + 1)%2;

    }else if (actionMode == 'vertical'){
      // ACTION MODE VERTICAL
      if (actionStage == 0){
        design.activePoint = mouse.nearest(points);
      }else if (actionStage == 1){
        constraints.add(
          new VerticalConstraint( design.activePoint, mouse.nearest(points)));
      }
      actionStage = (actionStage + 1)%2;

    }else if (actionMode == 'move-point'){
      // ACTION MODE MOVE POINT
      if (actionStage == 0){
        design.activePoint = mouse.nearest(points);
      }else if (actionStage == 1){
        design.activePoint.x = mx;
        design.activePoint.y = my;
      }
      actionStage = (actionStage + 1)%2;
    } else if (actionMode == "activate-point"){
      design.activePoint = mouse.nearest(points);
    }
  });

  // --------------------------------------------------------
  // BUTTON MODE SELECTION
  // --------------------------------------------------------

  querySelector("#add-points").addEventListener('click', (MouseEvent event){
    actionMode = 'add-points';
    actionStage = 0;
  });
  querySelector("#dimension").addEventListener('click', (MouseEvent event){
    actionMode = "dimension";
    actionStage = 0;
  });
  querySelector("#vertical").addEventListener('click', (MouseEvent event){
    actionMode = "vertical";
    actionStage = 0;
  });
  querySelector("#horizontal").addEventListener('click', (MouseEvent event){
    actionMode = "horizontal";
    actionStage = 0;
  });
  querySelector("#move-point").addEventListener('click', (MouseEvent event){
    actionMode = "move-point";
    actionStage = 0;
  });
  querySelector("#activate-point").addEventListener('click', (MouseEvent event){
    actionMode = "activate-point";
    actionStage = 0;
  });
}
