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
    vx = (x-oldX) * friction;
    vy = (y-oldY) * friction;
    
    oldX = x;
    oldY = y;
    x += vx;
    y += vy;
  }
  
  void constrain(){
    if (x < 0){
      x = 0;
      oldX = x + vx*bounce;
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
}

class Ball extends Point{
  Ball(float x_, float y_, float oldX_, float oldY_){
    super(x_, y_, oldX_, oldY_);
  }
  Ball(float x_, float y_, boolean pinned_){
    super(x_, y_, pinned_);
  }
  Ball(float x_, float y_){
    super(x_, y_);
  }
  
  void update(){
    if (pinned) return;
    
    vx = (x-oldX) * friction;
    vy = (y-oldY) * friction;
    
    if (y >= height) vx *= groundFriction;
    
    oldX = x;
    oldY = y;
    x += vx;
    y += vy;
    
    y += gravity;
  }
}
