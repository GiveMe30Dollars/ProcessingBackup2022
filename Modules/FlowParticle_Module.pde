
float [][] noiseMap;
float zoom = 0.1;
int octaves = 1;
float lacunarity = 1.5;
float persistence = 0.3;

float maxSpeed = 5;
float forceMultiplier = 25;
float gravityMultiplier = 0.02;
float damping = 0.7;

class FlowParticle extends Transform{
  PVector velocity;
  PVector force;
  boolean enabled = true;
  color c;
  
  FlowParticle(float x_, float y_){
    super(x_,y_);
    velocity = new PVector(0,0);
    force = new PVector(0,0);
  }
    
  void update(float[][] noiseMap){
    if (!enabled) return;
    
    force = new PVector(0,0);
    
    PVector flowDir = calculateGradient(noiseMap);
    flowDir.rotate(HALF_PI);
    force.add(flowDir.mult(forceMultiplier));
    
    PVector gravity = new PVector(width/2-x, height/2-y);
    float magnitude = gravity.mag() - width/3;
    gravity.setMag(magnitude).mult(gravityMultiplier);
    if (magnitude < 0) gravity.mult(gravityMultiplier);
    force.add(gravity);
    
    velocity.mult(damping);
    velocity.add(force);
    velocity.limit(maxSpeed);
    x += velocity.x;
    y += velocity.y;
    
    if (x < 1 || x >= width-1 || y < 1 || y >= height-1){
      enabled = false;
    }
  }
  PVector calculateGradient(float[][] noiseMap){
    int x_ = floor(x);
    int y_ = floor(y);
    float deltaX = x-x_;
    float deltaY = y-y_;
    
    float topLeft = noiseMap[x_][y_];
    float topRight = noiseMap[x_+1][y_];
    float bottomLeft = noiseMap[x_][y_+1];
    float bottomRight = noiseMap[x_+1][y_+1];
    
    float forceX = lerp(topRight, bottomRight, deltaY) - lerp(topLeft, bottomLeft, deltaY);
    float forceY = lerp(bottomLeft, bottomRight, deltaX) - lerp(topLeft, topRight, deltaX);
    return new PVector(forceX, forceY);
  }
  
  void show(color c_, float alpha){
    noStroke();
    color c = color(red(c_), green(c_), blue(c_), alpha);
    fill(c);
    circle(x,y,2);
  }
}

class Transform{
  float x, y;
  Transform(float x_, float y_){
    x = x_;
    y = y_;
  }
}
