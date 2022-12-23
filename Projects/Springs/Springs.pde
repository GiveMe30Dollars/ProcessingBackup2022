VerletSystem<Point, Elastick> v;
Cloth c;
float size = 100;
float elasticity = 0.05;

void setup(){
  size(1000,1000);
  background(0);
  frameRate(30);
  v = new VerletSystem();
  elasticity = pow(random(0.7),2) + 0.05;
  /*
  // SQUARE DEMO
  Point p1 = new Point(150+random(100), 150+random(100), new PVector(25,0).rotate(random(TWO_PI)));
  Point p2 = new Point(600-random(100), 150+random(100), new PVector(25,0).rotate(random(TWO_PI)));
  Point p3 = new Point(150+random(100), 250+random(100), new PVector(25,0).rotate(random(TWO_PI)));
  Point p4 = new Point(600-random(100), 250+random(100), new PVector(25,0).rotate(random(TWO_PI)));
  
  Elastick s1 = new Elastick(p1, p2, size, elasticity);
  Elastick s2 = new Elastick(p2, p4, size, elasticity);
  Elastick s3 = new Elastick(p3, p4, size, elasticity);
  Elastick s4 = new Elastick(p1, p3, size, elasticity);
  Elastick s5 = new Elastick(p1, p4, size*1.4421, elasticity);
  Elastick s6 = new Elastick(p2, p3, size*1.4421, elasticity);
  
  v.addPoint(p1);
  v.addPoint(p2);
  v.addPoint(p3);
  v.addPoint(p4);
  v.addStick(s1);
  v.addStick(s2);
  v.addStick(s3);
  v.addStick(s4);
  v.addStick(s5);
  v.addStick(s6);
  */
  
  /*
  // TRIANGLE DEMO
  Point p1 = new Point(random(width), random(height), new PVector(15,0).rotate(random(TWO_PI)));
  Point p2 = new Point(random(width), random(height), new PVector(15,0).rotate(random(TWO_PI)));
  Point p3 = new Point(random(width), random(height), new PVector(15,0).rotate(random(TWO_PI)));
  Elastick s1 = new Elastick(p1, p2, size, elasticity);
  Elastick s2 = new Elastick(p2, p3, size, elasticity);
  Elastick s3 = new Elastick(p3, p1, size, elasticity);
  v.addPoint(p1);
  v.addPoint(p2);
  v.addPoint(p3);
  v.addStick(s1);
  v.addStick(s2);
  v.addStick(s3);
  */
  
  c = new Cloth(50, 40, 12, 5, 0.3);
  
  //if (frameCount == 0) recordStart(-1, "Exports/DUMP.mp4",30);
}

float prevMouseX;
float prevMouseY;
Line cuttingLine;
boolean holdingRC = false;
int cooldown;
boolean keyNotPressed = true;

void draw(){
  // BASIC VISUALS
  //background(0);
  
  // WIND VISUALS
  /*
  PImage prev = get();
  background(0);
  if (mouseButton == LEFT) tint(50,100,128,200);
  if (mouseButton == RIGHT) tint(230,190,100,200);
  if (mousePressed) image(prev,0,0);*/
  
  // CUT VISUALS
  
  PImage prev = get();
  background(0);
  tint(100,0,0,200);
  if (cooldown >= 0) tint(lerp(100,255,(float)cooldown/30f), 0, 0, 200);
  if (mouseButton == LEFT && mousePressed) tint(200,0,0,200);
  if (mouseButton == RIGHT && mousePressed) tint(255,0,0,200);
  image(prev,0,0);
  
  /*
  Point p1 = v.points.get(0);
  //p1.x = mouseX;
  //p1.y = mouseY;
  v.update();
  v.show();*/
  
  // CLOTH DEMO
  c.update(50);
  c.show();
  /*
  // WIND DEMO
  if (mousePressed) c.wind();
  
  strokeWeight(3);
  if (!mousePressed){
    stroke(255); fill(0);
  }
  if (mouseButton == LEFT){
    stroke(50,100,128); fill(50,100,128);
  }
  if (mouseButton == RIGHT){
    stroke(230,190,100); fill(230,190,100);
  }
  circle(mouseX, mouseY, 10);
  */
  
  // CUTING DEMO
  if (mouseButton == LEFT && mousePressed) c.cut(new LineSegment(pmouseX, pmouseY, mouseX, mouseY));
  if (holdingRC && !mousePressed){
    cooldown = 30;
    c.cut(cuttingLine);
  }
  if (!(mousePressed && mouseButton == RIGHT)){
    prevMouseX = mouseX;
    prevMouseY = mouseY;
  }
  if (keyPressed && key == ' ' && keyNotPressed){
    cooldown = 30;
    keyNotPressed = false;
    c.decimate(0.05);
  }
  if (!keyPressed) keyNotPressed = true;
  holdingRC = mouseButton == RIGHT;
  cooldown--;
  /*
  if (frameCount % 45 == 0){
    cooldown = 30;
    c.decimate(0.01);
  }*/
  
  strokeWeight(3);
  if (!mousePressed){
    stroke(255); fill(0);
  }
  if (mousePressed){
    stroke(200,0,0); fill(200,0,0);
    cuttingLine = new Line(prevMouseX, prevMouseY, mouseX, mouseY);
    cuttingLine.show(#ff0000, 3);
    circle(prevMouseX, prevMouseY, 10);
  }
  if (cooldown >= 0 && !mousePressed){
    stroke(lerpColor(#ffffff, #ff0000, (float)cooldown/30f));
    fill(lerpColor(0, #ff0000, (float)cooldown/30f));
  }
  circle(mouseX, mouseY, 10);
  
  textSize(20);
  //text("Elasticity Value: " + elasticity, 10, 25);
  
  
  //if (frameCount % 200 == 0) setup();
  
  print(frameRate +"\n");
  //recordUpdate();
  
}

void mousePressed(){
  //c.addWind();
}

void keyPressed(){
  if (keyCode == ENTER) setup();
}
