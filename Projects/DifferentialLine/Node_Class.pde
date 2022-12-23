class Node extends Transform{
  PVector velocity;
  PVector force;
  Node(float x_, float y_){
    super(x_,y_);
    velocity = new PVector(0,0);
    force = new PVector(0,0);
  }
  
  void repel(Quadtree<Node> qTree, float rejectionRadius, float rejectionMultiplier){
    Circle c = new Circle(x,y,rejectionRadius);
    ArrayList<Node> query = qTree.query(c);
    for (Node neighbour : query){
      if (neighbour == this) continue;
      PVector displacement = new PVector(neighbour.x-x, neighbour.y-y);
      float magnitude = -rejectionMultiplier/displacement.mag();
      force.add(displacement.normalize().mult(magnitude));
    }
  }
  
  void attract(Node other, float attractionMultiplier, float attractionLimit){
    PVector displacement = new PVector(other.x-x, other.y-y);
    float magnitude = displacement.mag() * attractionMultiplier;
    force.add(displacement.normalize().mult(magnitude).limit(attractionLimit));
  }
  
  void update(){
    force.limit(maxForce);
    velocity.mult(damping);
    velocity.add(force);
    x += velocity.x;
    y += velocity.y;
    force = new PVector(0,0);
  }
  
  void show(){
    noStroke();
    color c = color(255,255,255,8);
    fill(c);
    circle(x,y,1);
  }
  
  void debugShow(){
    noStroke();
    fill(255);
    circle(x,y,4);
  }
}

class Edge{
  Node n1;
  Node n2;
  Edge(Node n1_, Node n2_){
    n1 = n1_;
    n2 = n2_;
  }
  
  void show(){
    
    noStroke();
    color c = color(255,255,255,8);
    fill(c);
    for(float i = 0; i < 1; i += 0.2){
      float x = lerp(n1.x, n2.x, i);
      float y = lerp(n1.y, n2.y, i);
      circle(x,y,1);
    }
    /*
    color c = color(255,255,255,8);
    stroke(c);
    noFill();
    line(n1.x, n1.y, n2.x, n2.y);*/
  }
  
  void debugShow(){
    stroke(255);
    line(n1.x, n1.y, n2.x, n2.y);
  }
  
  float lenSquared(){
    return pow((n2.x-n1.x),2) + pow((n2.y-n1.y),2);
  }
}
