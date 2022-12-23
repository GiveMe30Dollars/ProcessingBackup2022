class Particle extends Transform{
  float r;
  color c;
  Particle(float x_, float y_, float r_){
    super(x_,y_);
    r = r_;
    c = color(255);
  }
  Particle(float x_, float y_, float r_, color c_){
    super(x_,y_);
    r = r_;
    c = c_;
  }
  void update(float amt){
    x += random(amt*2)-amt;
    y += random(amt*2)-amt;
    
    PVector towardsCenter = new PVector(width/2-x, height/2-y);
    towardsCenter.normalize().mult(random(0.06));
    x += towardsCenter.x;
    y += towardsCenter.y;
  }
  
  void constrain(){
    if (x < 0) x = 0;
    if (x > width) x = width;
    if (y < 0) y = 0;
    if (y > height) y = height;
  }
  
  void show(){
    fill(c); noStroke();
    circle(x,y,r);
  }
  void show(color c_){
    fill(c_); noStroke();
    circle(x,y,r);
  }
  void show(color c_, float r_){
    fill(c); noStroke();
    circle(x,y,r_);
  }
}

class DLASystem{
  ArrayList<Particle> wanderers;
  ArrayList<Particle> aggregate;
  DLASystem(){
    wanderers = new ArrayList<Particle>();
    aggregate = new ArrayList<Particle>();
    
    colorMode(HSB);
    color col = color(0, 255, 200);
    colorMode(RGB);
    aggregate.add(new Particle(width/2, height/2, radius, col));
    //aggregate.add(new Particle(width/2, height/2, radius, 255));
  }
  
  void addWanderer(){
    int val = floor(random(4));
    Particle p = new Particle(0,0,0);
    switch(val){
      case 0:
        p = new Particle(random(width), 0, radius);
        break;
      case 1:
        p = new Particle(random(width), height, radius);
        break;
      case 2:
        p = new Particle(0, random(height), radius);
        break;
      case 3:
        p = new Particle(width, random(height), radius);
        break;
    }
    wanderers.add(p);
  }
  
  void update(float stickiness){
    if (wanderers.size() <= 0) return;
    Quadtree<Particle> qTree = new Quadtree<Particle>(capacity);
    qTree.insert(aggregate);
    
    for (int i = wanderers.size()-1; i >= 0; i--){
      Particle wanderer = wanderers.get(i);
      //wanderer.r = radius;
      wanderer.update(2);
      wanderer.constrain();
      
      Circle c = new Circle(wanderer.x, wanderer.y, radius*2);
      ArrayList<Particle> collidingAggregate = qTree.query(c);
      if ((wanderer.x < 0 || collidingAggregate.size() > 0) && random(1) < stickiness){
        
        color prev = collidingAggregate.get(0).c;
        colorMode(HSB); 
        color col = color((hue(prev)+random(20)-7)%256, 255, 255); 
        colorMode(RGB);
        wanderer.c = col;
        
        aggregate.add(wanderer);
        qTree.insert(wanderer);
        wanderers.remove(i);
        
        //radius *= 0.9995;
      }
    }
  }
  void update(){
    update(1);
  }
  
  void show(){
    for (Particle p : wanderers){
      p.show(128);
    }
    for (Particle p : aggregate){
      p.show();
    }
  }
}
