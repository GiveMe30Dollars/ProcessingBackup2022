class FidenzaPoint extends Transform{
  float r;
  FidenzaPoint(float x_, float y_, float r_){
    super(x_,y_);
    r = r_;
  }
}

class FidenzaStrip{
  float x;
  float y;
  PVector velocity, force;
  float r;
  ArrayList<FidenzaPoint> collisionData;
  boolean moving = true;
  Float minX, maxX, minY, maxY;
  int lifetime = -1;
  FidenzaStrip(float x_, float y_, float r_){
    x = x_;
    y = y_;
    r = r_;
    collisionData = new ArrayList<FidenzaPoint>();
    force = new PVector();
    velocity = new PVector(0,0);
    minX = Float.POSITIVE_INFINITY;
    minY = Float.POSITIVE_INFINITY;
    maxX = Float.NEGATIVE_INFINITY;
    maxY = Float.NEGATIVE_INFINITY;
  }
  
  void update(float scale, int seed){
    if (!moving) return;
    
    noiseSeed(seed);
    float value = noise(x*scale,y*scale);
    force = PVector.fromAngle(value*TWO_PI).mult(speedMultiplier);
    
    velocity.mult(damping);
    velocity.add(force);
    velocity.limit(maxSpeed);
    x += velocity.x;
    y += velocity.y;
    
    if (moving) updateCollisionData();
    if (lifetime == 0) moving = false;
    lifetime--;
  }
  void update(){
    update(0.005, 0);
  }
  
  void updateCollisionData(){
    collisionData.add(new FidenzaPoint(x,y,r));
    minX = min(minX, x-r);
    minY = min(minY, y-r);
    maxX = max(maxX, x+r);
    maxY = max(maxY, y+r);
  }
  
  void checkCollision(ArrayList<FidenzaStrip> strips, float maxRadius){
    if (x < 0 - canvasMargin * 2){    // COLLISION WITH CANVAS
      moving = false;
      return;
    }
    if (x > width + canvasMargin * 2){
      moving = false;
      return;
    }
    if (y < 0 - canvasMargin * 2){
      moving = false;
      return;
    }
    if (y > height + canvasMargin * 2){
      moving = false;
      return;
    }
    
    Quadtree<FidenzaPoint> qTree = new Quadtree<FidenzaPoint>();    // COLLISION BETWEEN OTHER STRIPS
    for (FidenzaStrip other : strips){
      if (other == this) continue;
      if (other.minX > this.maxX) continue;
      if (other.minY > this.maxY) continue;
      if (other.maxX < this.minX) continue;
      if (other.maxY < this.minY) continue;
      if (other.collisionData.size() <= 2) continue;
      qTree.insert(other.collisionData);
    }
    Circle circle = new Circle(x,y, r + maxRadius + stripMargin);
    ArrayList<FidenzaPoint> potentialCollisions = qTree.query(circle);
    
    for (FidenzaPoint candidate : potentialCollisions){
      float suitableDistance = r + candidate.r + stripMargin;
      float actualDistanceSq = pow(candidate.x - x, 2) + pow(candidate.y - y, 2);
      //print(actualDistanceSq + "    " + pow(suitableDistance,2) + "\n");
      if (actualDistanceSq <= pow(suitableDistance,2)){
        moving = false;
        return;
      }
    }
  }
  
  void show(color c){
    noFill(); 
    stroke(c);
    strokeWeight(r);
    //strokeCap(ROUND);
    strokeCap(SQUARE);
    //strokeCap(PROJECT);
    
    beginShape();
    for (FidenzaPoint p : collisionData){
      vertex(p.x, p.y);
      
    }
    endShape();
    
  }
  void show(){
    show(255);
  }
}
