ArrayList<Walker> points;
Quadtree<Walker> qTree;
ArrayList<Walker> waltz;
float margin = 20;

void setup(){
  background(0);
  size(900, 900);
  points = new ArrayList<Walker>();
  waltz = new ArrayList<Walker>();
  for (int i = 0; i < 2000; i++){
    points.add(new Walker(margin+random(width-2*margin), margin+random(height-2*margin)));
  }
  for (int i = 0; i < 200; i++){
    waltz.add(new Walker(margin+random(width-2*margin), margin+random(height-2*margin)));
  }
}

void draw(){
  PImage canvas = get();
  background(0);
  tint(230,230,150,200);
  image(canvas,0,0);
  
  for (Walker w : points){
    //w.update();
    w.show(color(100),4);
  }
  for (Walker w : waltz){
    w.update();
    //w.show(color(32),4);
  }
  
  qTree = new Quadtree<Walker>();
  qTree.insert(points);
  //qTree.show();
  
  //Point mousePos = new Point(mouseX, mouseY);
  for (Walker w : waltz){
    Walker closest = qTree.closestPoint(w);
    //closest.show(color(0,255,0), 10);
    fill(255,255,200); stroke(255,255,200); strokeWeight(2); noStroke();
    //line(w.x, w.y, closest.x, closest.y);
    
    for (int i = 0; i < 30; i++){
      float t = sqrt(random(1));
      float tx = lerp(w.x, closest.x, t) + randomGaussian()*2;
      float ty = lerp(w.y, closest.y, t) + randomGaussian()*2;
      circle(tx, ty, 1.5);
    }
  }
  
  //saveFrame("Quantized/####.png");
  //if (frameCount >= 1800) noLoop();
  print(frameCount + "    " + frameRate + "\n");
}
