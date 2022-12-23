Ball[] balls = new Ball[6];

void setup(){
  size(1000,1000);
  for (int i = 0; i < balls.length; i++){
    balls[i] = new Ball(random(width), random(height));
  }
  
  //recordStart(3600,"Exports/Lines.mp4");
}

void draw(){
  background(0);
  for (Ball x : balls){
    x.update();
  }
  
  Line a = new Line(balls[1].x, balls[1].y, balls[0].x, balls[0].y);
  //LineSegment a = new LineSegment(balls[1].x, balls[1].y, balls[0].x, balls[0].y);
  
  Line b = new Line(balls[2].x, balls[2].y, balls[3].x, balls[3].y);
  //LineSegment b = new LineSegment(balls[2].x, balls[2].y, balls[3].x, balls[3].y);
  
  Line c = new Line(balls[4].x, balls[4].y, balls[5].x, balls[5].y);
  //LineSegment c = new LineSegment(balls[4].x, balls[4].y, balls[5].x, balls[5].y);
  
  PVector intersectionAB = intersects(a,b);
  PVector intersectionAC = intersects(a,c);
  PVector intersectionBC = intersects(c,b);
  
  for (Ball x : balls){
    x.show();
  }
  a.show(150);
  b.show(150);
  c.show(150);
  
  stroke(0,255,0); noFill(); strokeWeight(3);
  if (intersectionAB != null){
    circle(intersectionAB.x, intersectionAB.y, 15);
  }
  if (intersectionAC != null){
    circle(intersectionAC.x, intersectionAC.y, 15);
  }
  if (intersectionBC != null){
    circle(intersectionBC.x, intersectionBC.y, 15);
  }
  
  //recordUpdate();
}
