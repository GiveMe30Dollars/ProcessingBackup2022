class Wanderer extends Transform{
  float r;
  boolean isColliding;
  
  Wanderer(float x_, float y_, float r_){
    super(x_,y_);
    r = r_;
    isColliding = false;
  }
  
  void update(Quadtree<Wanderer> quadtree){
    x += random(-5,5);
    y += random(-5,5);
    Circle bumpRange = new Circle(x,y,r*2);
    ArrayList<Wanderer> colliders = quadtree.query(bumpRange);
    if (colliders.size() > 1) isColliding = true;
    else isColliding = false;
  }
  
  void update(ArrayList<Wanderer> wanderers){
    x += random(-5,5);
    y += random(-5,5);
    Circle bumpRange = new Circle(x,y,r*2);
    isColliding = false;
    for (Wanderer w : wanderers){
      if (bumpRange.contains(w) && w.x != x && w.y != y) isColliding = true;
    }
  }
  
  void show(color active, color passive){
    noStroke();
    if (isColliding) fill(active);
    else fill(passive);
    circle(x,y,r);
  }
}
