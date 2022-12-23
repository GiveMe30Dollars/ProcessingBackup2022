float chargeDamping = 0.01;
float poleDamping = 0.9;
float maxChargeSpeed = 4;
float maxPoleSpeed = 20;

float chargeMultiplier = 20000;
float flowMultiplier = 1.0;
float gravityMultiplier = 0.1;
float circleSize = 1000/3;

class Charge extends Transform{
  float c;
  PVector velocity;
  int spawnFrame;
  Charge(float x_, float y_, float c_){
    super(x_,y_);
    c = c_;
    velocity = new PVector(0,0);
    spawnFrame = frameCount;
  }
  
  void update(PVector force){
    velocity.mult(chargeDamping);
    velocity.add(force.mult(chargeMultiplier));
    velocity.limit(maxChargeSpeed);
    x += velocity.x; 
    y += velocity.y;
  }
  
  void move(){
    PVector force = new PVector(0,0);
    PVector flowDir = PVector.random2D();
    force.add(flowDir.mult(flowMultiplier));
    
    PVector gravity = new PVector(width/2-x, height/2-y);
    float magnitude = gravity.mag() - circleSize;
    gravity.setMag(magnitude).mult(gravityMultiplier);
    if (magnitude < 0) gravity.mult(gravityMultiplier);
    force.add(gravity);
    
    velocity.mult(poleDamping);
    velocity.add(force);
    velocity.limit(maxPoleSpeed);
    x += velocity.x;
    y += velocity.y;
  }
  
  void show(){
    show(color(255,255,255,255),#ffffff,0,3);
  }
  void show(color fill, color stroke, float radius){
    show(fill, stroke, 0, radius);
  }
  void show(color fill, color stroke, float strokeWeight, float radius){
    fill(fill); stroke(stroke); strokeWeight(strokeWeight);
    if (strokeWeight <= 0) noStroke();
    else noFill();
    circle(x,y,radius);
  }
  
  void show(PGraphics pg){
    show(color(255,255,255,255),#ffffff,0,2,pg);
  }
  void show(color fill, color stroke, float strokeWeight, float radius, PGraphics pg){
    pg.fill(fill); pg.stroke(stroke); pg.strokeWeight(strokeWeight);
    if (strokeWeight <= 0) pg.noStroke();
    else pg.noFill();
    pg.circle(x,y,radius);
  }
}

class Transform{
  float x;
  float y;
  Object ref;
  Transform(float x_, float y_){
    x = x_;
    y = y_;
  }
}
