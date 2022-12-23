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
    c =  y1 - m*x1;
  }
  Line(float x1_, float y1_, Float m_){
    x1 = x1_;
    y1 = y1_;
    m = m_;
    c =  y1 - m*x1;
    x2 = 0;
    y2 = evaluateX(x2);
    if (m.isInfinite()){
      x2 = x1;
      y2 = 0;
    }
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
  
  int sideOfLine(float x, float y){
    float d = (x-x1)*(y2-y1) - (y-y1)*(x2-x1);
    return (int)Math.signum(d);
  }
  
  boolean validate(float x, float y){    // ASSUMING x,y INTERSECTS WITH LINE, IS IT VALID?
    return true;    // FOR LINE, TRUE ALWAYS. HERE TO ENSURE CHILDREN CAN INHERIT THE FUNCTION
  }
  
  void show(int col, float strokeW){
    stroke(col); strokeWeight(strokeW);
    line(0, c, width, evaluateX(width));
    Float mSelf = m;
    if (mSelf.isInfinite()){
      line(x1, 0, x2, height);
    }
  }
}

class Segment extends Line{
  Segment(float x1_, float y1_, float x2_, float y2_){
    super(x1_, y1_, x2_, y2_);
  }
  
  float length(){
    return sqrt(pow(x2-x1, 2) + pow(y2-y1, 2));
  }
  
  void show(int col, float strokeW){
    stroke(col); strokeWeight(strokeW);
    line(x1, y1, x2, y2);
  }
  
  boolean validate(float x, float y){
    if (!m.isInfinite()) return !(x < min(x1,x2) || x > max(x1,x2));
    else return !(y < min(y1,y2) || y > max(y1,y2));
  }
}

<T extends Line> PVector intersects(T a, T b){
  
  
  PVector candidate = null;    // INTERSECTION DEFINITELY EXISTS IF ONE LINE IS VERTICAL
  
  // VERTICAL LINE HANDLING, GRADIENT = INFINITY OR -INFINITY
  if (a.m.isInfinite() && b.m.isInfinite()) return null;    // BOTH VERTICAL LINES ARE PARALLEL.    IF THIS FAILS, ONLY ONE LINE IS PARALLEL (OR BOTH AREN'T PARALLEL)
  if (a.m == b.m) return null;    // LINES ARE PARALLEL (NOT VERTICAL)
  
  if (a.m.isInfinite()) candidate = new PVector(a.x1, b.evaluateX(a.x1));    // LINES ARE NOT PARALLEL, MUST INTERSECT AT VERTICAL LINE
  else if (b.m.isInfinite()) candidate = new PVector(b.x1, a.evaluateX(b.x1));    // Y VALUE MUST BE EVALUATED WITH NON-VERTICAL LINE
  else{
    float x = (b.c - a.c) / (a.m - b.m);    // INTERSECTION POINT EXISTS, NOT VERTICAL LINES
    candidate = new PVector(x,a.evaluateX(x));
  }
  
  if (a.validate(candidate.x,candidate.y) && b.validate(candidate.x,candidate.y)) return candidate;
  return null;
}
