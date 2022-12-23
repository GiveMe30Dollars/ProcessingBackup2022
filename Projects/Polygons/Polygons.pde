Polygon p;
int num = 20;

void setup(){
  size(1000,1000);
  p = new Polygon();
  for (float theta = 0; theta < TWO_PI; theta += TWO_PI/num){
    float x = width/2 + (random(200)+200)*cos(theta);
    float y = height/2 + (random(200)+200)*sin(theta);
    p.addPoint(x,y);
  }
  p.isClosed = true;
}

void draw(){
  background(0);
  p.show();
}

void mouseClicked(){
  p = chaikinCurve(p);
}

void keyPressed(){
  setup();
}
