/*
class Transform{
  float x;
  float y;
  Object ref;
  Transform(float x_, float y_){
    x = x_; y = y_;
  }
}*/

class Polygon implements Cloneable{
  ArrayList<Transform> points;
  Transform centroid;
  boolean isClosed = true;
  Polygon(){
    points = new ArrayList<Transform>();
  }
  Polygon(ArrayList<Transform> points_){
    points = points_;
    calculateCentroid();
  }
  Polygon(ArrayList<Transform> points_, boolean isClosed_){
    points = points_;
    isClosed = isClosed_;
    calculateCentroid();
  }
  
  
  public Object clone(){
    try{
      return super.clone();  
    }
    catch (CloneNotSupportedException c){ return null;}
  } 
  
  
  void add(float x, float y){
    points.add(new Transform(x,y));
    calculateCentroid();
  }
  void add(Transform newPoint){
    points.add(newPoint);
    calculateCentroid();
  }
  
  
  
  void calculateCentroid(){
    float sumX = 0;
    float sumY = 0;
    for (Transform t : points){
      sumX += t.x;
      sumY += t.y;
    }
    centroid = new Transform(sumX/(float)points.size(), sumY/(float)points.size());
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
    show(fillCol, strokeCol, weight, true);
  }
  void show(color fillCol, color strokeCol, float weight, boolean hasFill){
    if (hasFill){
      fill(fillCol); 
      noStroke();
      beginShape();
      for (int i = 0; i < points.size(); i++){
        Transform t = points.get(i);
        vertex(t.x, t.y);
      }
      if(isClosed) endShape(CLOSE);
      else endShape();
    }
    noFill(); stroke(strokeCol); strokeWeight(weight);
    if (weight <= 0) return;
    for (int i = 0; i < points.size(); i++){
      Transform t1 = points.get(i);
      Transform t2 = points.get((i+1)%points.size());
      line(t1.x, t1.y, t2.x, t2.y);
    }
  }
  void show(color fillCol, color strokeCol, float weight, boolean hasFill, PGraphics pg){
    if (hasFill){
      pg.fill(fillCol); 
      pg.noStroke();
      pg.beginShape();
      for (int i = 0; i < points.size(); i++){
        Transform t = points.get(i);
        pg.vertex(t.x, t.y);
      }
      if(isClosed) pg.endShape(CLOSE);
      else pg.endShape();
    }
    pg.noFill(); pg.stroke(strokeCol); pg.strokeWeight(weight);
    if (weight <= 0) return;
    for (int i = 0; i < points.size(); i++){
      Transform t1 = points.get(i);
      Transform t2 = points.get((i+1)%points.size());
      pg.line(t1.x, t1.y, t2.x, t2.y);
    }
  }
  
  
  
  void chaikinCurve(){
    chaikinCurve(0.25,1,-1);
  }
  void chaikinCurve(float percentage, int num){
    chaikinCurve(percentage, num, -1);
  }
  void chaikinCurve(float percentage){
   chaikinCurve(percentage, 1, -1);
  }
  void chaikinCurve(float percentage, int num, float threshold){
    for (int j = 0; j < num; j++){
      Polygon output = new Polygon();
      
      int lowerBound, upperBound;    // IF OPEN, ONLY ITERATE FROM 1 TO MAXIMUM-1, KEEP ENDPOINTS INTACT AND INCLUDED
      if (!isClosed){
        output.isClosed = false;
        output.add(points.get(0));
        lowerBound = 1; upperBound = points.size()-1;
      }
      else{    // IF CLOSED, USE ALL POINTS
        lowerBound = 0; upperBound = points.size();
      }
      
      for (int i = lowerBound; i < upperBound; i++){
        Transform current = points.get(i);    // GET ALL RELEVANT POINTS: PREVIOUS, CURRENT AND NEXT
        Transform previous, next;
          
        if (i <= 0) previous = points.get(points.size()-1);
        else previous = points.get(i-1);
        if (i >= points.size()-1) next = points.get(0);
        else next = points.get(i+1);
        
        float distanceCP = sqrt(pow(current.x-previous.x,2) + pow(current.y-previous.y,2));    // GETS PERCENTAGE OF MAXIMUM DISPLACEMENT. LOWEST PERCENTAGE IS USED FOR CREATING POINTS OF NEXT ITERATION
        float percentageCP = threshold/distanceCP;
        if (threshold <= 0) percentageCP = Float.MAX_VALUE;    // IF DISABLED, ENSURE THIS PERCENTAGE IS NEVER SELECTED
        float distanceCN = sqrt(pow(current.x-next.x,2) + pow(current.y-next.y,2));
        float percentageCN = threshold/distanceCN;
        if (threshold <= 0) percentageCN = Float.MAX_VALUE;
      
        Transform newPrevious = lerp(current, previous, min(percentage,percentageCP));
        Transform newNext = lerp(current, next, min(percentage,percentageCN));
        output.add(newPrevious);
        output.add(newNext);
      }
      
      if (!isClosed) output.add(points.get(points.size()-1));
      
      points = output.points;
    }
    calculateCentroid();
  }
  
  
  void scale(float scale){
    scale(scale, centroid);
  }
  void scale(float scale, Transform center){
    Polygon output = new Polygon();
    for (Transform t : points){
      PVector displacementFromCenter = new PVector(t.x-center.x, t.y-center.y);
      displacementFromCenter.mult(scale);
      Transform newT = new Transform(displacementFromCenter.x + center.x, displacementFromCenter.y + center.y);
      output.add(newT);
    }
    points = output.points;
    calculateCentroid();
  }
  
  void crop(float amnt){
    crop(amnt, centroid);
  }
  void crop(float amnt, Transform center){
    Polygon output = new Polygon();
    for (Transform t : points){
      PVector displacementFromCenter = new PVector(t.x-center.x, t.y-center.y);
      displacementFromCenter.setMag(max(0,displacementFromCenter.mag() - amnt));    // NO INVERSION OF POLYGONS IN CASE VALUE GOES BELOW 0
      Transform newT = new Transform(displacementFromCenter.x + center.x, displacementFromCenter.y + center.y);
      output.add(newT);
    }
    points = output.points;
    calculateCentroid();
  }
  
  void rotate(float angle){
    rotate(angle,centroid);
  }
  void rotate(float angle, Transform center){
    Polygon output = new Polygon();
    for (Transform t : points){
      PVector displacementFromCenter = new PVector(t.x-center.x, t.y-center.y);
      displacementFromCenter.rotate(angle*PI/180);
      Transform newT = new Transform(displacementFromCenter.x + center.x, displacementFromCenter.y + center.y);
      output.add(newT);
    }
    points = output.points;
  }
  
  
  void clip(Polygon mask){    // BOTH POLYGONS MUST WIND ANTICLOCKWISE FOR RESULT TO BE IN POLYGON
    if (!mask.isClosed) return; 
    ArrayList<Transform> tempResult = new ArrayList<Transform>();
    
    for (int j = 0; j < mask.points.size(); j++){
      
      Transform maskCurrent = mask.points.get(j);
      Transform maskNext = mask.points.get((j+1) % mask.points.size());
      Line cuttingLine = new Line(maskCurrent.x, maskCurrent.y, maskNext.x, maskNext.y);    // GENERATE CUTTING LINE
      
      for (int i = 0; i < points.size(); i++){
        Transform current = points.get(i);
        Transform next = points.get((i+1) % points.size());
        Segment edge = new Segment(current.x, current.y, next.x, next.y);
        
        if (cuttingLine.sideOfLine(current.x, current.y) >= 0){    // IF CURRENT POINT IS INSIDE OF MASK, ADD
          tempResult.add(current);
          if (cuttingLine.sideOfLine(next.x, next.y) < 0){    // IF NEXT POINT IS OUTSIDE, ADD INTERSECTION
            PVector intersection = intersects(cuttingLine, edge);
            if (intersection == null) continue;
            tempResult.add(new Transform(intersection.x, intersection.y));
          }
        }
        else if (cuttingLine.sideOfLine(next.x, next.y) > 0) {    // IF CURRENT POINT IS OUTSIDE BUT NEXT POINT IS INSIDE, ADD INTERSECTION
          PVector intersection = intersects(cuttingLine, edge);
          if (intersection == null) continue;
          tempResult.add(new Transform(intersection.x, intersection.y));
        }
      }
      
      points = tempResult;    // UPDATE POINTS THAT ARE CUT FOR THE NEXT ROUND
      tempResult = new ArrayList<Transform>();    // CLEAR TEMP RESULT. FINAL RESULT SHOWN WHEN ALL IS DONE
    }
    calculateCentroid();
  }
  
  void clipInverse(Polygon mask){    // BOTH POLYGONS MUST WIND ANTICLOCKWISE FOR RESULT TO BE IN POLYGON
    if (!mask.isClosed) return; 
    ArrayList<Transform> tempResult = new ArrayList<Transform>();
    
    for (int j = 0; j < mask.points.size(); j++){
      
      Transform maskCurrent = mask.points.get(j);
      Transform maskNext = mask.points.get((j+1) % mask.points.size());
      Line cuttingLine = new Line(maskCurrent.x, maskCurrent.y, maskNext.x, maskNext.y);    // GENERATE CUTTING LINE
      
      for (int i = 0; i < points.size(); i++){
        Transform current = points.get(i);
        Transform next = points.get((i+1) % points.size());
        Segment edge = new Segment(current.x, current.y, next.x, next.y);
        
        if (cuttingLine.sideOfLine(current.x, current.y) <= 0){    // IF CURRENT POINT IS INSIDE OF MASK, ADD
          tempResult.add(current);
          if (cuttingLine.sideOfLine(next.x, next.y) > 0){    // IF NEXT POINT IS OUTSIDE, ADD INTERSECTION
            PVector intersection = intersects(cuttingLine, edge);
            if (intersection == null) continue;
            tempResult.add(new Transform(intersection.x, intersection.y));
          }
        }
        else if (cuttingLine.sideOfLine(next.x, next.y) < 0) {    // IF CURRENT POINT IS OUTSIDE BUT NEXT POINT IS INSIDE, ADD INTERSECTION
          PVector intersection = intersects(cuttingLine, edge);
          if (intersection == null) continue;
          tempResult.add(new Transform(intersection.x, intersection.y));
        }
      }
      
      points = tempResult;    // UPDATE POINTS THAT ARE CUT FOR THE NEXT ROUND
      tempResult = new ArrayList<Transform>();    // CLEAR TEMP RESULT. FINAL RESULT SHOWN WHEN ALL IS DONE
    }
    calculateCentroid();
  }
  
}

Transform lerp(Transform a, Transform b, float p){
  float newX = lerp(a.x, b.x, p);
  float newY = lerp(a.y, b.y, p);
  return new Transform(newX, newY);
}
