/*
Quadtree<Point> qTree;
ArrayList<Point> points;
float rangeWidth = 300;
float rangeHeight = 200;
float rangeRadius = 300;
*/

Quadtree<Wanderer> qTree;
ArrayList<Wanderer> wanderers;

void setup(){
  background(25);
  size(1000,1000);
  
  /*
  qTree = new Quadtree<Point>(0,0,1000,1000,10);
  for (int i = 0; i < 5000; i++){
    Point p = new Point(random(width), random(height));
    qTree.insert(p);
  }
  background(25);
  qTree.show();
  */
  wanderers = new ArrayList<Wanderer>();
  qTree = new Quadtree<Wanderer>(0,0,width,height,50);
  for (int i = 0; i < 5000; i++){
    Wanderer w = new Wanderer(random(width), random(height), 5);
    qTree.insert(w);
    wanderers.add(w);
  }
}

void draw(){
  /*
  Circle range = new Circle(mouseX, mouseY, rangeRadius);
  //Rectangle range = new Rectangle(mouseX-rangeWidth/2, mouseY-rangeHeight/2, rangeWidth, rangeHeight);
  
  ArrayList<Point> includedPoints = qTree.query(range);
  background(25);
  qTree.show();
  for (Point p : includedPoints){
    p.show(color(0,255,0), 6);
  }
  range.show(color(0,255,0), 5)*/
  
  background(25);
  qTree.reset();
  qTree.insert(wanderers);
  qTree.show();
  for (Wanderer w : wanderers){
    w.update(qTree);
    //w.update(wanderers);
    w.show(color(0,255,0), color(255));
  }
  print(frameRate + "\n");
}
