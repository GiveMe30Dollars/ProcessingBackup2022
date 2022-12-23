int collatz(int i){
  if (i % 2 == 1) return 3*i+1;
  else return i/2;
}

IntList collatzSeries(int i_){
  int i = i_;
  IntList list = new IntList();
  list.append(i);
  while (i > 1){
    i = collatz(i);
    list.append(i);
  }
  return list;
}

void drawCollatzSeries(int i, color c, float thickness, PVector root, PVector direction){
  
  IntList list = new IntList();
  list = collatzSeries(i);
  PVector pos = new PVector(root.x, root.y);
  PVector move = new PVector(direction.x, direction.y);
  
  noFill();
  stroke(c);
  strokeWeight(thickness);
  
  beginShape();
  curveVertex(pos.x, pos.y);
  
  for (int j = list.size()-1; j >= 0; j--){
    if (list.get(j) % 2 == 1) move.rotate(leftAngle);
    else move.rotate(rightAngle);
    pos.add(move);
    curveVertex(pos.x, pos.y);
  }

  curveVertex(pos.x, pos.y);
  endShape();
  
}




int number = 39;
float leftAngle = -radians(10);
float rightAngle = radians(5);
float turtleLength = 2;

PVector start;
PVector startDir;

int range = 20000;

void setup(){
  background(25);
  size(1000,1000);
  
  start = new PVector(width/2, height);
  startDir = new PVector(0, -turtleLength);
  
  for (int i = 1; i < range; i++){
    drawCollatzSeries(i, color(255,255,255,5), 2, start, startDir);
  }
}

void draw(){
  
}
