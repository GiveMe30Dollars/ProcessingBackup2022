class Stick <T extends Point>{
  T p1;
  T p2;
  float l;
  boolean isVisible = true;
  Stick(T p1_, T p2_, float length_, boolean iV_){
    p1 = p1_;
    p2 = p2_;
    l = length_;
    isVisible = iV_;
  }
  Stick(T p1_, T p2_, float length_){
    p1 = p1_;
    p2 = p2_;
    l = length_;
  }
  Stick(T p1_, T p2_, boolean iV_){
    p1 = p1_;
    p2 = p2_;
    l = distance(p1, p2);
    isVisible = iV_;
  }
  Stick(T p1_, T p2_){
    p1 = p1_;
    p2 = p2_;
    l = distance(p1, p2);
  }
  
  void update(){
    float dx = p2.x - p1.x;
    float dy = p2.y - p1.y;
    float distance = sqrt(dx*dx + dy*dy);
    float difference = l - distance;
    float percent = difference / distance / 2;
    
    if (p1.pinned || p2.pinned) percent *= 2;
    float offsetX = dx*percent;
    float offsetY = dy*percent;
    
    if (!p1.pinned){
      p1.x -= offsetX;
      p1.y -= offsetY;
    }
    if (!p2.pinned){
      p2.x += offsetX;
      p2.y += offsetY;
    }
  }
  
  void show(){
    if (!isVisible) return;
    stroke(255); strokeWeight(1.5); noFill();
    line(p1.x, p1.y, p2.x, p2.y);
  }
}

float distance(Point p1, Point p2){
  return sqrt(pow(p1.x-p2.x,2) + pow(p1.y-p2.y,2));
}
