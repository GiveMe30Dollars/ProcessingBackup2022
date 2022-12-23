//GEOMETRY CLASS

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






// TRANSFORM CLASS

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






// QUADTREE CLASS

class Quadtree <T extends Transform> extends Rectangle{
  Quadtree childTL;
  Quadtree childTR;
  Quadtree childBL;
  Quadtree childBR;
  boolean divided;
  int capacity;
  ArrayList<T> points;
  Quadtree(float x_, float y_, float w_, float h_, int c_){
    super(x_, y_, w_, h_);
    divided = false;
    capacity = c_;
    points = new ArrayList<T>();
  }
  Quadtree(int c_){
    super(0, 0, width, height);
    divided = false;
    capacity = c_;
    points = new ArrayList<T>();
  }
  Quadtree(){
    super(0, 0, width, height);
    divided = false;
    capacity = 20;
    points = new ArrayList<T>();
  }
  
  void reset(){
    childTL = null;
    childTR = null;
    childBL = null;
    childBR = null;
    divided = false;
    points = new ArrayList<T>();
  }
  
  void insert(ArrayList<T> array){
    for (T t : array){
      insert(t);
    }
  }
  
  void insert(T t){
    if (!contains(t)) return;
    if (!divided){
      points.add(t);
      if (points.size() <= capacity) return;
      childTL = new Quadtree(x, y, w/2, h/2, capacity);
      childTR = new Quadtree(x+w/2, y, w/2, h/2, capacity);
      childBL = new Quadtree(x, y+h/2, w/2, h/2, capacity);
      childBR = new Quadtree(x+w/2, y+h/2, w/2, h/2, capacity);
      for (T q : points){
        childTL.insert(q);
        childTR.insert(q);
        childBL.insert(q);
        childBR.insert(q);
      }
      points = null;
      divided = true;
      return;
    }
    childTL.insert(t);
    childTR.insert(t);
    childBL.insert(t);
    childBR.insert(t);
  }
  
  
  <T2 extends Geometry> ArrayList<T> query(T2 range){
    ArrayList<T> queryArray = new ArrayList<T>();
    query(range, queryArray);
    return queryArray;
  }
  
  
  <T2 extends Geometry> void query(T2 range, ArrayList<T> queryArray){
    if (!intersects(range)) return;
    if (!divided){
      for (T t : points){
        if (range.contains(t)) queryArray.add(t);
      }
      return;
    }
    childTL.query(range, queryArray);
    childTR.query(range, queryArray);
    childBL.query(range, queryArray);
    childBR.query(range, queryArray);
  }
  
  
  void show(){
    super.show();
    if (!divided){
      for (T p : points){
        p.show();
      }
      return;
    }
    childTL.show();
    childTR.show();
    childBL.show();
    childBR.show();
  }
}
