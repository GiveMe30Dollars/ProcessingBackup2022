//
/*noiseMap = layeredNoise(width, height, zoom, octaves, lacunarity, persistence);
  particles = new ArrayList<VParticle>();
  for (int i = 0; i < 100; i++){
    //VParticle p = new VParticle(random(width-2)+1, random(height-2)+1);
    VParticle p = new VParticle(random(width-margin*2)+margin, random(height-margin*2)+margin);
    particles.add(p);
  }
  
  if (frameCount % 10 == 0) particles.add(new VParticle(random(width-margin*2)+margin, random(height-margin*2)+margin));
  for (VParticle p : particles){
    p.update(noiseMap);
  }*/
//


float maxSpeed = 20;
float flowMultiplier = 1.5;
float gravityMultiplier = 0.2;
float relaxationMultiplier = 0.55;
float relaxationLimit = 100;
float damping = 0.9;

class VParticle extends Transform{
  PVector velocity;
  PVector force;
  boolean enabled = true;
  color col;
  PVector constantForce;
  
  VParticle(float x_, float y_){
    super(x_,y_);
    velocity = new PVector(0,0);
    force = new PVector(0,0);
    constantForce = new PVector(0,0);
  }
  
  void update(Polygon p){
    force = new PVector(0,0);
    
    
    PVector flowDir = PVector.random2D();
    flowDir.rotate(HALF_PI);
    force.add(flowDir.mult(flowMultiplier));
    /*
    PVector gravity = new PVector(width/2-x, height/2-y);
    float magnitude = gravity.mag() - circleSize;
    gravity.setMag(magnitude).mult(gravityMultiplier);
    if (magnitude < 0) gravity.mult(0);
    force.add(gravity);
    */
    
    if (p != null){
      PVector displacement = new PVector(p.centroid.x-x, p.centroid.y-y);
      force.add(displacement.mult(relaxationMultiplier).limit(relaxationLimit));
    }
    
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

/*
class Transform{
  float x;
  float y;
  Transform(float x_, float y_){
    x = x_; y = y_;
  }
}
*/
