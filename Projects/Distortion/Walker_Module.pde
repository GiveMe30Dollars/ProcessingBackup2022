float maxSpeed = 20;
float flowMultiplier = 1.5;
float gravityMultiplier = 0.2;
float relaxationMultiplier = 0.55;
float relaxationLimit = 100;
float damping = 0.9;
float circleSize = 100;

class Walker extends Transform{
  PVector velocity;
  PVector force;
  boolean enabled = true;
  color col;
  PVector constantForce;
  
  Walker(float x_, float y_){
    super(x_,y_);
    velocity = new PVector(0,0);
    force = new PVector(0,0);
    constantForce = new PVector(0,0);
  }
  
  void update(){
    force = new PVector(0,0);
    PVector flowDir = PVector.random2D();
    force.add(flowDir.mult(flowMultiplier));
    
    PVector gravity = new PVector(width/2-x, height/2-y);
    float magnitude = gravity.mag() - circleSize;
    gravity.setMag(magnitude).mult(gravityMultiplier);
    if (magnitude < 0) gravity.mult(0);
    force.add(gravity);
    
    force.add(constantForce);
    
    velocity.mult(damping);
    velocity.add(force);
    velocity.limit(maxSpeed);
    x += velocity.x;
    y += velocity.y;
  }
  
  void show(color c_){
    noStroke();
    color c = c_;
    fill(c);
    circle(x,y,4);
  }
}


class Transform{
  float x;
  float y;
  Transform(float x_, float y_){
    x = x_; y = y_;
  }
}
