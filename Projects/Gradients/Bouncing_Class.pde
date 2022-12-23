class Ball{
  float x; float y;
  PVector velocity = new PVector(5,0).rotate(random(TWO_PI));
  Ball(float x_, float y_){
    x = x_;
    y = y_;
  }
  void update(){
    if (x <= 0) velocity.x = abs(velocity.x);
    if (x >= width) velocity.x = -abs(velocity.x);
    if (y <= 0) velocity.y = abs(velocity.y);
    if (y >= height) velocity.y = -abs(velocity.y);
    x += velocity.x;
    y += velocity.y;
  }
  
  void show(){
    noStroke();
    fill(0,0,16);
    circle(x,y,3);
  }
}
