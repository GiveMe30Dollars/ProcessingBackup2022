class Line{
  float x1; float y1;
  float x2; float y2;
  Float m;
  float c;
  Line(float x1_, float y1_, float x2_, float y2_){
    x1 = x1_;
    y1 = y1_;
    x2 = x2_;
    y2 = y2_;
    m = (y2-y1)/(x2-x1);
    c = y1 - m*x1;
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
  float length(){
    return Float.POSITIVE_INFINITY;
  }
  
  void show(int col, float strokeW){
    stroke(col); strokeWeight(strokeW);
    line(0, c, width, evaluateX(width));
    if (m.isInfinite()){
      line(x1, 0, x2, height);
    }
  }
}

class LineSegment extends Line{
  LineSegment(float x1_, float y1_, float x2_, float y2_){
    super(x1_, y1_, x2_, y2_);
  }
  
  float length(){
    return sqrt(pow(x2-x1, 2) + pow(y2-y1, 2));
  }
  
  void show(int col, float strokeW){
    stroke(col); strokeWeight(strokeW);
    line(x1, y1, x2, y2);
  }
}

boolean boundingBox(Line l, LineSegment s){
  if (l.m.isInfinite()){
    if (l.x1 > max(s.x1, s.x2)) return false;
    if (l.x1 < min(s.x1, s.x2)) return false;
    return true;
  }
  float y1 = l.evaluateX(s.x1);
  float y2 = l.evaluateX(s.x2);
  float ymin = min(s.y1, s.y2);
  float ymax = max(s.y1, s.y2);
  if (ymin <= y1 && y1 <= ymax) return true;
  if (ymin <= y2 && y2 <= ymax) return true;
  if (y1 < ymin && y2 > ymax) return true;
  if (y2 < ymin && y1 > ymax) return true;
  return false;
}

<T extends Line> PVector intersects(T a, T b){
  
  // VERTICAL LINE HANDLING, GRADIENT = INFINITY OR -INFINITY
  Float mA = (Float)a.m;
  Float mB = (Float)b.m;
  if (mA.isInfinite() && mB.isInfinite()) return null;    // BOTH VERTICAL LINES ARE PARALLEL.    IF THIS FAILS, ONLY ONE LINE IS PARALLEL (OR BOTH AREN'T PARALLEL)
  PVector candidatePoint = null;    // INTERSECTION DEFINITELY EXISTS IF ONE LINE IS VERTICAL
  
  if (mA.isInfinite()) candidatePoint = new PVector(a.x1, b.evaluateX(a.x1));    // LINES ARE NOT PARALLEL, MUST INTERSECT AT VERTICAL LINE
  if (mB.isInfinite()) candidatePoint = new PVector(b.x1, a.evaluateX(b.x1));    // Y VALUE MUST BE EVALUATED WITH NON-VERTICAL LINE
  
  if (candidatePoint != null){    // IF CANDIDATE POINT EXISTS FOR INTERSECTION OF ONLY ONE VERTICAL LINE
    if (a instanceof LineSegment && mA.isInfinite()){
      if (candidatePoint.y < min(a.y1, a.y2) || candidatePoint.y > max(a.y1, a.y2)) return null;    // CHECK IF CANDIDATE POINT IS WITHIN RANGE OF VERTICAL LINE SEGMENT A, INVALID OTHERWISE
    }
    if (b instanceof LineSegment && !mB.isInfinite()){    // IF OTHER LINE IS ALSO SEGMENT
        if (candidatePoint.x < min(b.x1, b.x2) || candidatePoint.x > max(b.x1, b.x2)) return null;    //  CHECK WHETHER CANDIDATE POINT IS WITHIN RANGE OF LINE SEGMENT B, INVALID OTHERWISE
    }
    if (b instanceof LineSegment && mB.isInfinite()){
      if (candidatePoint.y < min(b.y1, b.y2) || candidatePoint.y > max(b.y1, b.y2)) return null;    // CHECK IF CANDIDATE POINT IS WITHIN RANGE OF VERTICAL LINE SEGMENT B, INVALID OTHERWISE
    }
    if (a instanceof LineSegment && !mA.isInfinite()){    // IF OTHER LINE IS ALSO SEGMENT
        if (candidatePoint.x < min(a.x1, a.x2) || candidatePoint.x > max(a.x1, a.x2)) return null;    //  CHECK WHETHER CANDIDATE POINT IS WITHIN RANGE OF LINE SEGMENT A, INVALID OTHERWISE
    }
    return candidatePoint;
  }
  
  if (a.m == b.m) return null;    // LINES ARE PARALLEL
  float x = (b.c - a.c) / (a.m - b.m);    // INTERSECTION POINT EXISTS
  if (a instanceof LineSegment){
    if (x < min(a.x1, a.x2) || x > max(a.x1, a.x2)) return null;    // INTERSECTION NOT ON LINE SEGMENT A, INVALID
  }
  if (b instanceof LineSegment){
    if (x < min(b.x1, b.x2) || x > max(b.x1, b.x2)) return null;    // INTERSECTION NOT ON LINE SEGMENT B, INVALID
  }
  return new PVector(x, a.evaluateX(x));
}
