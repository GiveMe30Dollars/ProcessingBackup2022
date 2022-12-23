/*
class Transform{
  float x;
  float y;
  Transform(float x_, float y_){
    x = x_; y = y_;
  }
}*/

class Polygon{
  ArrayList<Transform> points;
  Transform center;
  boolean isClosed = true;
  Polygon(){
    points = new ArrayList<Transform>();
  }
  Polygon(ArrayList<Transform> points_){
    points = points_;
    calculateCenter();
  }
  Polygon(ArrayList<Transform> points_, boolean isClosed_){
    points = points_;
    isClosed = isClosed_;
    calculateCenter();
  }
  
  void add(float x, float y){
    points.add(new Transform(x,y));
    calculateCenter();
  }
  void add(Transform newPoint){
    points.add(newPoint);
    calculateCenter();
  }
  
  void calculateCenter(){
    float sumX = 0;
    float sumY = 0;
    for (Transform t : points){
      sumX += t.x;
      sumY += t.y;
    }
    center = new Transform(sumX/(float)points.size(), sumY/(float)points.size());
  }
  
  void show(){
    fill(128); stroke(255); strokeWeight(3);
    beginShape();
    for (int i = 0; i < points.size(); i++){
      Transform t = points.get(i);
      vertex(t.x, t.y);
    }
    if(isClosed) endShape(CLOSE);
    else endShape();
  }
  
  void show(color fillCol, color strokeCol, float weight){
    fill(fillCol); stroke(strokeCol); strokeWeight(weight);
    beginShape();
    for (int i = 0; i < points.size(); i++){
      Transform t = points.get(i);
      vertex(t.x, t.y);
    }
    if(isClosed) endShape(CLOSE);
    else endShape();
  }
  
  void show(color fillCol, color strokeCol, float weight, PGraphics pg){
    fill(fillCol); stroke(strokeCol); strokeWeight(weight);
    pg.beginShape();
    for (int i = 0; i < points.size(); i++){
      Transform t = points.get(i);
      pg.vertex(t.x, t.y);
    }
    if(isClosed) pg.endShape(CLOSE);
    else pg.endShape();
  }
}

Transform lerp(Transform a, Transform b, float p){
  float newX = lerp(a.x, b.x, p);
  float newY = lerp(a.y, b.y, p);
  return new Transform(newX, newY);
}

Polygon chaikinCurve(Polygon base){
  if (base.isClosed) return chaikinCurve(base, 0.25, true);
  else return chaikinCurve(base, 0.25, false);
}
Polygon chaikinCurve(Polygon base, float percentage){
  if (base.isClosed) return chaikinCurve(base, percentage, true);
  else return chaikinCurve(base, percentage, false);
}
Polygon chaikinCurve(Polygon base, float percentage, boolean isClosed){
  Polygon output = new Polygon();
  if (!isClosed){
    output.isClosed = false;
    output.add(base.points.get(0));
    for (int i = 1; i < base.points.size()-1; i++){
      Transform current = base.points.get(i);
      Transform previous = base.points.get(i-1);
      Transform next = base.points.get(i+1);
      
      Transform newPrevious = lerp(current, previous, percentage);
      Transform newNext = lerp(current, next, percentage);
      output.add(newPrevious);
      output.add(newNext);
    }
    output.add(base.points.get(base.points.size()-1));
  }
  else{
    for (int i = 0; i < base.points.size(); i++){
      Transform current = base.points.get(i);
      Transform previous, next;
      if (i <= 0) previous = base.points.get(base.points.size()-1);
      else previous = base.points.get(i-1);
      if (i >= base.points.size()-1) next = base.points.get(0);
      else next = base.points.get(i+1);
      
      Transform newPrevious = lerp(current, previous, percentage);
      Transform newNext = lerp(current, next, percentage);
      output.add(newPrevious);
      output.add(newNext);
    }
  }
  return output;
}

Polygon scale(Polygon base, float scale){
  return scale(base, scale, base.center);
}
Polygon scale(Polygon base, float scale, Transform center){
  Polygon output = new Polygon();
  output.isClosed = base.isClosed;
  for (Transform t : base.points){
    PVector displacementFromCenter = new PVector(t.x-center.x, t.y-center.y);
    displacementFromCenter.mult(scale);
    Transform newT = new Transform(displacementFromCenter.x + center.x, displacementFromCenter.y + center.y);
    output.add(newT);
  }
  return output;
}
