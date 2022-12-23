class Particle extends Transform{
  float r;
  Particle(float x_, float y_, float r_){
    super(x_,y_);
    r = r_;
  }
  void update(){
    x -= 1;
    y += random(7) - 3.5f;
  }
  
  void constrain(){
    if (y > 0 || x <= 0.0000001){
      y = 0;
      return;
    }
    if (y/x < -1/1.73205){
      y = -(x/1.73205);
    }
  }
  void show(){
    fill(255); noStroke();
    circle(x,y,r);
  }
  void show(color c){
    fill(c); noStroke();
    circle(x,y,r);
  }
}

class Snowflake{
  ArrayList<Particle> wanderers;
  ArrayList<Particle> aggregate;
  Snowflake(){
    wanderers = new ArrayList<Particle>();
    aggregate = new ArrayList<Particle>();
    aggregate.add(new Particle(0, 0, radius));
  }
  
  void addWanderer(){
    //wanderers.add(new Particle(width/2, random(height/16)-height/16, radius));
    wanderers.add(new Particle(width/2, 0, radius));
  }
  
  void update(){
    if (wanderers.size() <= 0) return;
    Quadtree<Particle> qTree = new Quadtree<Particle>(-width, -height, width*2, height*2, capacity);
    for (Particle p : aggregate){
      qTree.insert(p);
    }
    for (int i = wanderers.size()-1; i >= 0; i--){
      Particle wanderer = wanderers.get(i);
      wanderer.update();
      wanderer.constrain();
      
      Circle c = new Circle(wanderer.x, wanderer.y, radius*2);
      if (wanderer.x < 0 || qTree.query(c).size() > 0){
        aggregate.add(wanderer);
        //qTree.insert(wanderer);
        wanderers.remove(i);
      }
    }
  }
  
  void show(){
    for(float i = 0; i < TWO_PI; i += PI/3){
      rotate(PI/3);
      for (Particle p : wanderers){
        p.show(128);
      }
      for (Particle p : aggregate){
        p.show();
      }
      pushMatrix();
      scale(1,-1);
      for (Particle p : wanderers){
        p.show(128);
      }
      for (Particle p : aggregate){
        p.show();
      }
      popMatrix();
    }
  }
}
