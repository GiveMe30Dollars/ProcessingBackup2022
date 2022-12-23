import java.util.*;

class AdaptiveCircle extends Transform{
  float r;
  float margin = 0;
  PVector velocity, force;
  AdaptiveCircle(float x_, float y_, float r_, float m_){
    super(x_,y_);
    r = r_/2;
    margin = m_;
    velocity = new PVector(0,0);
    force = new PVector(0,0);
  }
  AdaptiveCircle(float x_, float y_, float r_){
    super(x_,y_);
    r = r_;
    velocity = new PVector(0,0);
    force = new PVector(0,0);
  }
  
  void update(Quadtree<AdaptiveCircle> qTree, float maxRadius){
    Circle c = new Circle(x, y, maxRadius*2);
    ArrayList<AdaptiveCircle> collidingCircles = qTree.query(c);
    for (AdaptiveCircle candidate : collidingCircles){
      if (candidate == this) continue;
      float suitableDistance = r + candidate.r + margin + candidate.margin;
      PVector displacement = new PVector(candidate.x - x, candidate.y - y);
      float actualDistance = displacement.mag();
      if (actualDistance >= suitableDistance) continue;
      //if(frameCount > 100)print(r +"    "+ candidate.r +"    "+actualDistance + "    " + suitableDistance + "\n");
      
      
      float magnitude = suitableDistance-actualDistance;
      force.add(displacement.setMag(-collisionMultiplier*magnitude));
    }
    /*
    if (x < 0) force.add(new PVector(0-x,0));
    if (x > width) force.add(new PVector(width-x,0));
    if (y < 0) force.add(new PVector(0,0-y));
    if (y > height) force.add(new PVector(0,height-y));*/
    
    velocity.mult(damping);
    velocity.add(force);
    velocity.limit(maxSpeed);
    x += velocity.x;
    y += velocity.y;
    force = new PVector(0,0);
    
    //r = lerp(0,30,pow(noise(x*0.02,y*0.02),1.5))/2;
    //r = lerp(1,30,pow(domainWarping(x,y),lerp(0.1,4.0,x/(float)width)))/2;
    //margin = lerp(1,15,pow(noise(y*0.02,x*0.02),2.5));
    //margin = max(14-r,0.5);
  }
  
  void show(){
    //fill(noise(x*0.02,y*0.02)*256,noise(x*0.02,y*0.02)*256,noise(x*0.02,y*0.02)*256,200); //noStroke();
    //stroke(noise(x*0.02,y*0.02)*256); strokeWeight(3); noFill(); 
    //stroke(255); strokeWeight(r/15*10); noFill(); 
    fill(255); noStroke();
    circle(x,y,r*2);
    /*
    stroke(color(255,255,255,128)); strokeWeight(3); noFill();
    circle(x,y,(r+r+margin*4));
    circle(x,y,(r+r+margin*2));
    circle(x,y,(r+r));*/
  }
}

class PackingSystem{
  ArrayList<AdaptiveCircle> circles;
  float maxRadius = 0;
  float maxMargin = 0;
  PackingSystem(){
    circles = new ArrayList<AdaptiveCircle>();
  }
  
  void addCircle(float x_, float y_, float r_, float m_){
    circles.add(new AdaptiveCircle(x_,y_,r_,m_));
    //Collections.shuffle(circles);
    maxRadius = max(maxRadius, r_);
    maxMargin = max(maxMargin, m_);
  }
  
  void update(int amount){
    Quadtree<AdaptiveCircle> qTree = new Quadtree();
    qTree.insert(circles);
    for (int i = 0; i < amount; i++){
      for (AdaptiveCircle c : circles){
        c.update(qTree, maxRadius+maxMargin);
      }
    }
  }
  
  void show(){
    for (AdaptiveCircle c : circles){
      c.show();
    }
  }
}
