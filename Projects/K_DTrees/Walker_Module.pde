//
/*noiseMap = layeredNoise(width, height, zoom, octaves, lacunarity, persistence);
  particles = new ArrayList<Walker>();
  for (int i = 0; i < 100; i++){
    //Walker p = new Walker(random(width-2)+1, random(height-2)+1);
    Walker p = new Walker(random(width-margin*2)+margin, random(height-margin*2)+margin);
    particles.add(p);
  }
  
  if (frameCount % 10 == 0) particles.add(new Walker(random(width-margin*2)+margin, random(height-margin*2)+margin));
  for (Walker p : particles){
    p.update(noiseMap);
  }*/
//


float maxSpeed = 20;
float flowMultiplier = 1.5;
float gravityMultiplier = 0.2;
float relaxationMultiplier = 0.55;
float relaxationLimit = 100;
float damping = 0.9;
float circleSize = 250;

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
  
  void show(color c_, float alpha){
    noStroke();
    color c = color(red(c_), green(c_), blue(c_), alpha);
    fill(c);
    circle(x,y,2);
  }
}


class Transform{
  float x;
  float y;
  Object ref;
  Transform(float x_, float y_){
    x = x_; y = y_;
  }
}
