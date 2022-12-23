float lightPercentage = 0.001;
int cooldownTime = 180;
int lightTime = 20;
int influenceDelay = 5;
int influenceNumber = 2;
int lightRange = 70;

float relaxationMultiplier = 155.55;
float relaxationLimit = 1000;

class Firefloid extends Boid{
  PVector velocity = new PVector();
  PVector force = new PVector();
  float maxSpeed;
  float mass;
  float range;
  float angle;
  Firefloid(float x_, float y_){
    super(x_, y_);
  }
  
  float cooldown = 0;
  
  void update(Quadtree<Firefloid> qTree, String dumb){
    
    super.update(qTree);
    
    if (random(1) <= lightPercentage) illuminate();
    if (cooldown > cooldownTime-lightTime && cooldown < cooldownTime-influenceDelay){
      ArrayList<Firefloid> neighbours = findNeighbours(qTree, lightRange, 360);
      for(int i = 0; i < influenceNumber; i++){
        if (neighbours.size() <= 0) break;
        int index = floor(random(neighbours.size()));
        Firefloid neighbour = neighbours.get(index);
        neighbour.illuminate();
        neighbours.remove(index);
      }
    }
    cooldown--;
  }
  
  void illuminate(){
    if (cooldown <= 0) cooldown = cooldownTime;
    //else if (cooldownTime-lightTime > cooldown) cooldown -= 5;
  }
  
  boolean isLit(){
    return cooldownTime-lightTime < cooldown;
  }
  
  void show(color outline, color fill, color illuminated, float size){
    stroke(outline);
    strokeWeight(2);
    fill(fill);
    if (cooldownTime-lightTime < cooldown){
      stroke(illuminated);
      fill(illuminated);
    }
    //line(x, y, x+(velocity.x/velocity.mag())*size, y+(velocity.y/velocity.mag())*size);
    circle(x,y,size);
  }
}
