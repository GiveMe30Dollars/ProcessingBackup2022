class Ball{
  float x; float y;
  PVector velocity;
  Ball(float x_, float y_){
    x = x_;
    y = y_;
    velocity = new PVector(2,0).rotate(random(TWO_PI));
  }
  
  void update(){
    x += velocity.x;
    y += velocity.y;
    if(x < 0) velocity.x = abs(velocity.x);
    if(x > width) velocity.x = -abs(velocity.x);
    if(y < 0) velocity.y = abs(velocity.y);
    if(y > height) velocity.y = -abs(velocity.y);
  }
  
  void show(){
    noStroke(); fill(200);
    circle(x,y,5);
  }
}
