import 'dart:math';

Random rng = new Random();

class DPoint{
  num x,y;
  DPoint([this.x = 0, this.y = 0]);

  num dist(DPoint b) => sqrt(pow(x - b.x,2) + pow(y - b.y,2));

  DPoint nearest(List<DPoint> points){
    List<num> distances = points.map(dist).toList(growable:false);
    num minDistance = distances.reduce(min);
    return points[distances.indexOf(minDistance)];
  }

  void jitter({num radius:.001}){
    x += rng.nextDouble() * radius * 2 - radius;
    y += rng.nextDouble() * radius * 2 - radius;
  }

  bool deviate(Function cb,{num radius: 1, num iters: 20}){
    num originalx = x,originaly = y;
    num score = cb(this);
    num bestScore = score;
    num opt_dx = 0, opt_dy = 0;

    for (int i = 0; i < iters; i++){
      num dx = cos(i/iters*PI*2) * radius;
      num dy = sin(i/iters*PI*2) * radius;
      x += dx;
      y += dy;
      var score = cb(this);
      if (score < bestScore){
        bestScore = score;
        opt_dx = dx;
        opt_dy = dy;
      }
      x = originalx;
      y = originaly;
    }

    if (opt_dx == 0 && opt_dy == 0){
      return false;
    }else{
      x += opt_dx;
      y += opt_dy;
      return true;
    }
  }

}
