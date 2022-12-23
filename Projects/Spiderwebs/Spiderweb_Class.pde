import java.util.*;

class Spiderweb extends VerletSystem{
  
  Spiderweb(float initialRadius, float initialNumber, float elasticity){
    super();
    float offset = 0.001;
    Point prev = null;
    for (float i = offset; i < TWO_PI+offset; i += TWO_PI/initialNumber){
      Point p = new Point(width/2 + initialRadius*cos(i), height/2 + initialRadius*sin(i));
      addPoint(p);
      if ((int)(i*initialNumber/TWO_PI) % 2 == 0) p.pinned = true;
      if (i != offset){
        Elastick e = new Elastick(prev, p, distance(prev, p), elasticity);
        addStick(e);
      }
      prev = p;
    }
    Point first = (Point)points.get(0);
    Point last = (Point)points.get((int)initialNumber-1);
    Elastick e = new Elastick(first, last, distance(first, last), elasticity);
    addStick(e);
    
    Collections.shuffle(sticks);
  }
  
  
  intersectionData findIntersections(Line l){
    Float gradient = l.m;
    boolean sortWithYValue = gradient.isInfinite();
    
    ArrayList<Integer> intersectingSticksIndex = new ArrayList<Integer>();
    ArrayList<Float> intersectionValue = new ArrayList<Float>();
    
    for (int i = 0; i < sticks.size(); i++){
      Elastick e = (Elastick)sticks.get(i);    // CHECK INTERSECTION FOR ALL SEGMENTS
      LineSegment segment = new LineSegment(e.p1.x, e.p1.y, e.p2.x, e.p2.y);
      PVector p = intersects(l, segment);
      if (p == null) continue;
      
      intersectingSticksIndex.add(i);    // CONFIRMED INTERSECTION, RECORD STICK ID/INDEX AND X POSITION (Y POSITION IF LINE IS VERTICAL)
      if (!sortWithYValue) intersectionValue.add(p.x);
      else intersectionValue.add(p.y);
    }
    
    float[] sortedValue = new float[intersectionValue.size()];    // THIS MESS SORTS THE INDEXES OF THE STICKS BASED ON THE X POSITION (SOMETIMES Y POSITION) OF INTERSECTION
    for (int i = 0; i < sortedValue.length; i++){
      sortedValue[i] = intersectionValue.get(i);
    }
    Arrays.sort(sortedValue);
    int[] order = new int[intersectionValue.size()];
    for (int i = 0; i < order.length; i++){
      int oldIndex = intersectionValue.indexOf(sortedValue[i]);
      order[oldIndex] = i;
    }
    int[] sortedSticksIndex = new int[intersectingSticksIndex.size()];
    for (int i = 0; i < sortedSticksIndex.length; i++){
      sortedSticksIndex[order[i]] = intersectingSticksIndex.get(i);
    }
    return new intersectionData(sortedValue, sortedSticksIndex, sortWithYValue);
  }
  
  
  void connect(Line l, float size, float elasticity){
    intersectionData data = findIntersections(l); 
    if (data.length <= 1) return;    // NOT ENOUGH LINES FOR BONDS
    
    //int lineChoice = floor(random(data.length - 1));    // CHOOSE RANDOM 2 NEIGHBOURING LINES TO FORM BOND
    
    int lineChoice = -1;    // CHOOSE 2 LINES WITH LARGEST DISTANCE BETWEEN INTERSECTION POINTS
    Float maximumDistance = Float.NEGATIVE_INFINITY;
    for (int i = 0; i < data.length - 1; i++){
      float value1 = data.sortedValue[i];
      float value2 = data.sortedValue[i+1];
      if (abs(value2-value1) > maximumDistance){
        lineChoice = i;
        maximumDistance = abs(value2-value1);
      }
    }
    
    Elastick e1 = (Elastick) sticks.get(data.sortedSticksIndex[lineChoice]);    // GET REFERENCE TO RELEVANT INTERSECTIONS AND STICKS
    Elastick e2 = (Elastick) sticks.get(data.sortedSticksIndex[lineChoice + 1]);
    Point p1, p2;
    if (!data.sortWithYValue){
      p1 = new Point(data.sortedValue[lineChoice], l.evaluateX(data.sortedValue[lineChoice]));
      p2 = new Point(data.sortedValue[lineChoice + 1], l.evaluateX(data.sortedValue[lineChoice + 1]));
    }
    else {
      p1 = new Point(l.x1, data.sortedValue[lineChoice]);
      p2 = new Point(l.x1, data.sortedValue[lineChoice + 1]);
    }
    
    points.add(p1); points.add(p2);    // PUT IN NEW POINTS
    Elastick ep1 = new Elastick(e1.p1, p1, distance(e1.p1, p1), elasticity);    // RECONSTRUCT STICKS WITH EXTRA POINTS
    Elastick pe1 = new Elastick(p1, e1.p2, distance(e1.p2, p1), elasticity);
    Elastick ep2 = new Elastick(e2.p1, p2, distance(e2.p1, p2), elasticity);
    Elastick pe2 = new Elastick(p2, e2.p2, distance(e2.p2, p2), elasticity);
    sticks.add(ep1);
    sticks.add(pe1);
    sticks.add(ep2);
    sticks.add(pe2);
    sticks.remove(sticks.indexOf(e1));    // REMOVE OFFENDING LINES
    sticks.remove(sticks.indexOf(e2));
    
    Elastick newEdge = new Elastick(p1, p2, distance(p1,p2)*size, elasticity);    // ADD NEW EDGE
    sticks.add(newEdge);
  }
  
  
  void connectAll(Line l, float size, float elasticity){
    intersectionData data = findIntersections(l);
    if (data.length <= 1) return;    // NOT ENOUGH INTERSECTIONS
    
    Elastick[] offendingSticks = new Elastick[data.length];    // STORED TO REMOVE POST-MORTEM; INDEXES CHANGE AFTER REMOVAL, BEST TO STORE OBJECT ITSELF
    Point prevP = null;
    for (int i = 0; i < data.length; i++){
      Elastick e = (Elastick) sticks.get(data.sortedSticksIndex[i]);
      Point p;
      if (!data.sortWithYValue) p = new Point(data.sortedValue[i], l.evaluateX(data.sortedValue[i]));
      else p = new Point(l.x1, data.sortedValue[i]);
      points.add(p);
      
      Elastick ep = new Elastick(e.p1, p, distance(e.p1, p), elasticity);    // RECONSTRUCT STICK WITH EXTRA POINTS
      Elastick pe = new Elastick(p, e.p2, distance(e.p2, p), elasticity);
      sticks.add(ep);
      sticks.add(pe);
      
      if (prevP != null){
        Elastick newEdge = new Elastick(p, prevP, distance(p,prevP)*size, elasticity);    // ADD NEW EDGE
        sticks.add(newEdge);
      }
      
      offendingSticks[i] = e;
      prevP = p;
    }
    
    for (int i = 0; i < offendingSticks.length; i++){
      if (offendingSticks[i] == null || sticks.indexOf(offendingSticks[i]) == -1) continue;
      sticks.remove(sticks.indexOf(offendingSticks[i]));
    }
  }
  
  
  void connectMost(Line l, float size, float elasticity, float threshold){
    intersectionData data = findIntersections(l);
    if (data.length <= 1) return;    // NOT ENOUGH INTERSECTIONS
    
    Elastick[] offendingSticks = new Elastick[data.length];    // STORED TO REMOVE POST-MORTEM; INDEXES CHANGE AFTER REMOVAL, BEST TO STORE OBJECT ITSELF
    Point prevP = null;
    for (int i = 0; i < data.length; i++){
      Elastick e = (Elastick) sticks.get(data.sortedSticksIndex[i]);
      Point p;
      if (!data.sortWithYValue) p = new Point(data.sortedValue[i], l.evaluateX(data.sortedValue[i]));
      else p = new Point(l.x1, data.sortedValue[i]);
      
      if (prevP == null || distance(prevP, p) < threshold){    // IF GAP EXCEEDS THRESHOLD OR NO PREVIOUS EDGE EXISTS, DONT SPLIT CURRENT EDGE, CONTINUE
        offendingSticks[i] = null;
        prevP = p;
        continue;
      }
      
      // MAKING NEW CONNECTION
      points.add(p);
      
      Elastick ep = new Elastick(e.p1, p, distance(e.p1, p)*size, elasticity);    // RECONSTRUCT STICK WITH EXTRA POINTS
      Elastick pe = new Elastick(p, e.p2, distance(e.p2, p)*size, elasticity);
      sticks.add(ep);
      sticks.add(pe);
      
      if (offendingSticks[i-1] == null){    // IF PREVIOUS EDGE IS NOT SPLIT, SPLIT PREVIOUS EDGE
        Elastick prevE = (Elastick) sticks.get(data.sortedSticksIndex[i-1]);
        points.add(prevP);
        Elastick prevEP = new Elastick(prevE.p1, prevP, distance(prevE.p1, prevP)*size, elasticity);    // RECONSTRUCT STICK WITH EXTRA POINTS
        Elastick prevPE = new Elastick(prevP, prevE.p2, distance(prevE.p2, prevP)*size, elasticity);
        sticks.add(prevEP);
        sticks.add(prevPE);
        offendingSticks[i-1] = prevE;    // QUEUE FOR NEWLY-SPLIT PREVIOUS EDGE
      }
      Elastick newEdge = new Elastick(p, prevP, distance(p,prevP)*size, elasticity);    // ADD NEW EDGE
      sticks.add(newEdge);
      
      offendingSticks[i] = e;
      prevP = p;
    }
    
    for (int i = 0; i < offendingSticks.length; i++){
      if (offendingSticks[i] == null || sticks.indexOf(offendingSticks[i]) == -1) continue;
      sticks.remove(sticks.indexOf(offendingSticks[i]));
    }
  }
  
}

class intersectionData{
  float[] sortedValue;
  int[] sortedSticksIndex;
  boolean sortWithYValue;
  int length;
  intersectionData(float[] SV_, int[] SSI_, boolean SWYV_){
    sortedValue = SV_;
    sortedSticksIndex = SSI_;
    sortWithYValue = SWYV_;
    length = sortedValue.length;
  }
}
