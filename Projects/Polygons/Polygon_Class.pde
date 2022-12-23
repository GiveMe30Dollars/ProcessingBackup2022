class Transform{
  float x;
  float y;
  Transform(float x_, float y_){
    x = x_; y = y_;
  }
}

class Polygon{
  ArrayList<Transform> points;
  boolean isClosed = true;
  Polygon(){
    points = new ArrayList<Transform>();
  }
  Polygon(ArrayList<Transform> points_){
    points = points_;
  }
  Polygon(ArrayList<Transform> points_, boolean isClosed_){
    points = points_;
    isClosed = isClosed_;
  }
  
  void addPoint(float x, float y){
    points.add(new Transform(x,y));
  }
  void addPoint(Transform newPoint){
    points.add(newPoint);
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
  Polygon result = new Polygon();
  if (!isClosed){
    result.isClosed = false;
    result.addPoint(base.points.get(0));
    for (int i = 1; i < base.points.size()-1; i++){
      Transform current = base.points.get(i);
      Transform previous = base.points.get(i-1);
      Transform next = base.points.get(i+1);
      
      Transform newPrevious = lerp(current, previous, percentage);
      Transform newNext = lerp(current, next, percentage);
      result.addPoint(newPrevious);
      result.addPoint(newNext);
    }
    result.addPoint(base.points.get(base.points.size()-1));
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
      result.addPoint(newPrevious);
      result.addPoint(newNext);
    }
  }
  return result;
}
