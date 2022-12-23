class Transform{
  float x;
  float y;
  Transform(float x_, float y_){
    x = x_;
    y = y_;
  }
  void show(){}
  void update(){}
}

class Point extends Transform{
  Point(float x_, float y_){
    super(x_,y_);
  }
  
  void show(){
    noStroke();
    fill(255);
    circle(x,y,4);
  }
  
  void show(color c, float r){
    noStroke();
    fill(c);
    circle(x,y,r);
  }
}
