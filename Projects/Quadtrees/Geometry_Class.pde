class Geometry{
  float x;
  float y;
  String typeof(){
    return "Geometry";
  }
  
  <T extends Transform> boolean contains(T p){
    return false;
  }
  <T extends Geometry> boolean intersects(T range){
    return true;
  }
}

class Rectangle extends Geometry{
  float x;
  float y;
  float w;
  float h;
  Rectangle(float x_, float y_, float w_, float h_){
    x = x_;
    y = y_;
    w = w_;
    h = h_;
  }
  String typeof(){
    return "Rectangle";
  }
  
  
  <T extends Transform> boolean contains (T p){
    return !(p.x < x || p.x > x+w ||
             p.y < y || p.y > y+h);
  }
  
  
  <T extends Geometry> boolean intersects(T range){
    switch (range.typeof()){
      case "Rectangle": return intersects((Rectangle) range);
      case "Circle": return intersects((Circle) range);
    }
    return true;
  }
  
  boolean intersects(Rectangle rect){
    return !(x > rect.x+rect.w || x+w < rect.x || y > rect.y+rect.h || y+h < rect.y);
  }
  
  boolean intersects(Circle circle){
    float closestX = max(x, min(circle.x, x+w));
    float closestY = max(y, min(circle.y, y+h));
    return (pow(closestX-circle.x,2) + pow(closestY-circle.y,2) <= pow(circle.r,2));
  }
  
  
  void show(){ show(color(255), 2); }
  void show(color c, float t){
    stroke(c);
    strokeWeight(t);
    noFill();
    rect(x,y,w,h);
  }
}

class Circle extends Geometry{
  float x;
  float y;
  float r;
  Circle(float x_, float y_, float r_){
    x = x_;
    y = y_;
    r = r_/2;
  }
  String typeof(){
    return "Circle";
  }
  
  
  <T extends Transform> boolean contains(T p){
    return (pow(p.x-x, 2) + pow(p.y-y, 2) <= pow(r, 2));
  }
  
  
  void show(){ show(color(255), 2); }
  void show(color c, float t){
    stroke(c);
    strokeWeight(t);
    noFill();
    circle(x,y,r*2);
  }
}
