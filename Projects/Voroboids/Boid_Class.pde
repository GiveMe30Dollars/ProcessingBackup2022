float maxSpeed = 8;
float mass = 1;
float viewRange = 55;
float viewAngle = 220;

float multiplier_A = 0.27;
float multiplier_C = 0.29;
float multiplier_S = 7.8;
float multiplier_O = 0.0017; 
//float multiplier_O = 0; 
float damping = 0.7;
float size = 7;

class Boid extends Transform{
  PVector velocity = new PVector();
  PVector force = new PVector();
  Boid(float x_, float y_){
    super(x_,y_);
    velocity = PVector.fromAngle(random(TWO_PI)).mult(maxSpeed);
    velocity.add(new PVector(0,-maxSpeed));
  }
  
  void show(color outline, color fill, float size){
    stroke(outline);
    strokeWeight(2);
    fill(fill);
    
    //line(x, y, x+(velocity.x/velocity.mag())*size, y+(velocity.y/velocity.mag())*size);
    circle(x,y,size);
  }
  
  void edgeCollide(){
    if (x<0) velocity.x = abs(velocity.x);
    if (y<0) velocity.y = abs(velocity.y);
    if (x>width) velocity.x = -abs(velocity.x);
    if (y>height) velocity.y = -abs(velocity.y);
  }
  
  void edgeWarp(){
    if (x<0) x = width;
    if (y<0) y = height;
    if (x>width) x = 0;
    if (y>height) y = 0;
  }
  
  <T extends Boid>void update(Quadtree<T> qTree){
    
    ArrayList<T> neighbours = findNeighbours(qTree, viewRange, viewAngle);
    
    force = velocity.get();
    force.mult(damping);
    force.rotate(random(-0.2,0.2));
    
    alignment(neighbours, multiplier_A);
    cohesion(neighbours, multiplier_C);
    separation(neighbours, multiplier_S);
    toCenter(multiplier_O);
    
    velocity.mult(damping);
    velocity.add(PVector.div(force,mass));
    
    velocity.limit(maxSpeed);
    //velocity.setMag(maxSpeed);
    
    //edgeCollide();
    edgeWarp();
    
    x += velocity.x;
    y += velocity.y;
  }
  
  <T extends Boid>ArrayList<T> findNeighbours(Quadtree<T> qTree, float range, float angle){
    Circle searchRange = new Circle(x,y,range);
    ArrayList<T> neighbours = qTree.query(searchRange);
    neighbours.remove(this);
    for (int i = neighbours.size()-1; i >= 0; i--){
      Boid n = neighbours.get(i);
      PVector displacement = new PVector(n.x-x, n.y-y);
      if (PVector.angleBetween(displacement, velocity)*180/PI > angle/2) neighbours.remove(n);
    }
    return neighbours;
  }
  
  <T extends Boid>void alignment(ArrayList<T> neighbours, float multiplier){
    if (neighbours.size() <= 0) return;
    PVector alignment = new PVector();
    for (Boid n : neighbours){
      alignment.add(n.velocity);
    }
    alignment.div(neighbours.size());
    alignment.mult(multiplier);
    force.add(alignment);
  }
  
  <T extends Boid>void cohesion(ArrayList<T> neighbours, float multiplier){
    if (neighbours.size() <= 0) return;
    PVector cohesion = new PVector();
    for (Boid n : neighbours){
      cohesion.add(new PVector(n.x,n.y));
    }
    cohesion.div(neighbours.size());
    cohesion.sub(new PVector(x,y));
    cohesion.mult(multiplier);
    force.add(cohesion);
  }
  
  <T extends Boid>void separation(ArrayList<T> neighbours, float multiplier){
    if (neighbours.size() <= 0) return;
    PVector separation = new PVector();
    for (Boid n : neighbours){
      PVector diff = new PVector(x-n.x, y-n.y);
      float d = diff.mag();
      diff.mult(1/d);
      separation.add(diff);
    }
    separation.div(neighbours.size());
    separation.mult(multiplier);
    force.add(separation);
  }
  
  void toCenter(float multiplier){
    PVector centralForce = new PVector(width/2-x, height/2-y);
    centralForce.mult(multiplier);
    centralForce.mult(pow(centralForce.mag(),2));
    force.add(centralForce);
  }
  /*
  void toCenter(float multiplier){
    PVector gravity = new PVector(width/2-x, height/2-y);
    float magnitude = gravity.mag() - circleSize;
    gravity.setMag(magnitude).mult(multiplier);
    //if (magnitude < 0) gravity.mult(multiplier);
    force.add(gravity);
  }*/
}
