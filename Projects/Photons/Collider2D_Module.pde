class Collider extends Polygon{
  
  ArrayList<ColliderEdge> edges;
  float refractiveIndex = -1;
  
  Collider(){
    super();
  }
  Collider(ArrayList<Transform> points_){
    super(points_);
    calculateLinesAndNormals();
  }
  Collider(ArrayList<Transform> points_, boolean isClosed_){
    super(points_, isClosed_);
    calculateLinesAndNormals();
  }
  Collider(Polygon source){
    super(source.points, source.isClosed);
    calculateLinesAndNormals();
  }
  
  void calculateLinesAndNormals(){
    
    edges = new ArrayList<ColliderEdge>();    // INITIALISE ARRAY
    
    int upperBound = isClosed ? points.size() : points.size() - 1;    // EXCLUDE LINE FROM LAST TO FIRST POINT IF NOT CLOSED
    for (int i = 0; i < upperBound; i++){    // FOR ALL POINTS, GET CORRESSPONDING NEXT POINT
      int nextIndex = (i+1)%points.size();
      Transform current = points.get(i);
      Transform next = points.get(nextIndex);
      
      ColliderEdge edge = new ColliderEdge(current.x, current.y, next.x, next.y, this);    // CONSTRUCT SEGMENT
      edges.add(edge);    // ASSUMES POINTS ARE NOT NULL OR INFINITE
      
    }
  }
  
  boolean contains(float x, float y){
    for (ColliderEdge e : edges){
      PVector pointedToLine = new PVector((e.x1+e.x2)/2 - x, (e.y1+e.y2)/2 - y);
      if (PVector.dot(pointedToLine, e.normal) <= 0 ) return false;
    }
    return true;
  }
  
}


class ColliderEdge extends Segment{
  PVector normal;
  Collider parent;
  ColliderEdge(float x1_, float y1_, float x2_, float y2_, Collider col){
    super(x1_,y1_,x2_,y2_);
    parent = col;
    normal = new PVector(x2-x1, y2-y1).normalize().rotate(HALF_PI);   // CONSTRUCT NORMAL, ASSUMES POINTS ARE WOUNDED COUNTERCLOCKWISE FOR OUTWARD REFLECTION
  }
  
  PVector collisionResponse(PVector remainingDIS){
    if (parent.refractiveIndex <= 0) return reflect(remainingDIS);
    else return refract(remainingDIS);
  }
  
  PVector reflect(PVector remainingDIS){
    float magnitude = PVector.dot(normal, remainingDIS);
    if (magnitude >= 0) return remainingDIS.copy();
    return remainingDIS.copy().sub(normal.copy().mult(2*magnitude));
  }
  
  PVector refract(PVector remainingDIS){
    // TODO
    return null;
  }
}
