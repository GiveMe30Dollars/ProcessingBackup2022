class Line{
  float x1; float y1;
  float x2; float y2;
  float m;
  float c;
  Line(float x1_, float y1_, float x2_, float y2_){
    x1 = x1_;
    y1 = y1_;
    x2 = x2_;
    y2 = y2_;
    m = (y2-y1)/(x2-x1);
    c =  y1 - m*x1;
  }
  void recalculate(){
    m = (y2-y1)/(x2-x1);
    c =  y1 - m*x1;
  }
  float evaluateX(float x){
    return m*x + c;
  }
  float evaluateY(float y){
    return (y - c) / m;
  }
  
  void show(int col){
    stroke(col); strokeWeight(1.5);
    line(0, c, width, evaluateX(width));
  }
}

class LineSegment extends Line{
  LineSegment(float x1_, float y1_, float x2_, float y2_){
    super(x1_, y1_, x2_, y2_);
  }
  
  void show(int col){
    stroke(col); strokeWeight(1.5);
    line(x1, y1, x2, y2);
  }
}

<T extends Line> PVector intersects(T a, T b){
  if (a.m == b.m) return null;    // LINES ARE PARALLEL
  float x = (b.c - a.c) / (a.m - b.m);    // INTERSECTION POINT EXISTS
  if (a instanceof LineSegment){
    if (x < min(a.x1, a.x2) || x > max(a.x2, a.x1)) return null;    // INTERSECTION NOT ON LINE SEGMENT A, INVALID
  }
  if (b instanceof LineSegment){
    if (x < min(b.x1, b.x2) || x > max(b.x2, b.x1)) return null;    // INTERSECTION NOT ON LINE SEGMENT B, INVALID
  }
  return new PVector(x, a.evaluateX(x));
}
