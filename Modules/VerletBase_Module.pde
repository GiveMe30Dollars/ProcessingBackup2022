float airFriction = 0.995;
//float groundFriction = 0.8;
float groundFriction = 1;
float bounce = 0.7;
float gravity = 1;
//float gravity = 0;

class Point{
  float x, y;
  float oldX, oldY;
  float vx, vy;
  boolean pinned = false;
  Point(float x_, float y_, boolean pinned_){
    x = x_;
    y = y_;
    oldX = x_;
    oldY = y_;
    pinned = pinned_;
  }
  Point(float x_, float y_, PVector velocity){
    x = x_;
    y = y_;
    oldX = x_ - velocity.x;
    oldY = y_ - velocity.y;
  }
  Point(float x_, float y_, float oldX_, float oldY_){
    x = x_;
    y = y_;
    oldX = oldX_;
    oldY = oldY_;
  }
  Point(float x_, float y_){
    x = x_;
    y = y_;
    oldX = x_;
    oldY = y_;
  }
  
  void update(){
    if (pinned) return;
    vx = (x-oldX) * airFriction;
    vy = (y-oldY) * airFriction;
    if (y >= height){
      vx *= groundFriction;
      vy *= groundFriction;
    }
    
    oldX = x;
    oldY = y;
    x += vx;
    y += vy;
    y += gravity;
  }
  void constrain(){
    if (x < 0){
      x = 0;
      oldX = x - vx*bounce;
    }
    if (x > width){
      x = width;
      oldX = x + vx*bounce;
    }
    if (y < 0){
      y = 0;
      oldY = y + vy*bounce;
    }
    if (y > height){
      y = height;
      oldY = y + vy*bounce;
    }
  }
  void show(){
    fill(255); noStroke();
    circle(x,y,5);
  }
  void show(int fillCol, int strokeCol, boolean enableFill, float strokeW, float radius){
    fill(fillCol); stroke(strokeCol);
    if (!enableFill) noFill();
    strokeWeight(strokeW);
    circle(x,y,radius);
  }
}



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
  Stick(){}
  
  void update(){
    float dx = p2.x - p1.x;
    float dy = p2.y - p1.y;
    float distance = sqrt(dx*dx + dy*dy);
    float difference = l - distance;
    float percent = difference / max(distance,0.00001) / 2;
    
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
  void show(int col, float strokeW){
    if (!isVisible) return;
    stroke(col); strokeWeight(strokeW);
    line(p1.x, p1.y, p2.x, p2.y);
  }
}

float distance(Point p1, Point p2){
  return sqrt(pow(p1.x-p2.x,2) + pow(p1.y-p2.y,2));
}



class VerletSystem <TPoint extends Point, TStick extends Stick>{
  ArrayList<TPoint> points;
  ArrayList<TStick> sticks;
  VerletSystem(){
    points = new ArrayList<TPoint>();
    sticks = new ArrayList<TStick>();
  }
  
  // ----- ADD SINGULAR COMPONENT-----
  
  void addPoint(TPoint p){
    points.add(p);
  }
  void addStick(TStick s){
    sticks.add(s);
  }
  void addStick(TPoint p1, TPoint p2, boolean isVisible){
    sticks.add((TStick)new Stick(p1,p2, isVisible));
  }
  void addStick(int i1, int i2, boolean isVisible){
    Point p1 = points.get(i1);
    Point p2 = points.get(i2);
    sticks.add((TStick)new Stick(p1,p2,isVisible));
  }
  void addStick(int i1, int i2){
    Point p1 = points.get(i1);
    Point p2 = points.get(i2);
    sticks.add((TStick)new Stick(p1,p2));
  }
  
  
  // -----ADD LIST OF COMPONENTS-----
  
  void addPoint(ArrayList<TPoint> pArray){
    for (TPoint p : pArray) points.add(p);
  }
  void addStick(ArrayList<TStick> sArray){
    for (TStick s : sArray) sticks.add(s);
  }
  
  void update(int stickUpdates){
    for (TPoint p : points){
      p.update();
    }
    for (int i = 0; i < stickUpdates; i++){
      for (TStick s : sticks){
        s.update();
      }
      for (TPoint p : points){
      p.constrain();
      }
    }
  }
  void update(){
    update(2);
  }
  
  void show(){
    for (TPoint p : points){
      p.show();
    }
    for (TStick s : sticks){
      s.show();
    }
  }
  
  void show(int fillCol, int strokeCol, float radius, float strokeWP, float strokeWS){
    for (TPoint p : points){
      p.show(fillCol, strokeCol, true, strokeWP, radius);
    }
    for (TStick s : sticks){
      s.show(strokeCol, strokeWS);
    }
  }
}
