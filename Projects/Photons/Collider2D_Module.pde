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
    if (parent.refractiveIndex < 0) return reflect(remainingDIS);
    else if (parent.refractiveIndex == 0) return new PVector(0,0);
    else return refract(remainingDIS);
  }
  
  
  PVector reflect(PVector vec){
    return reflect(vec, normal);
  }
  PVector reflect(PVector vec, PVector n_){
    float magnitude = PVector.dot(n_, vec);
    if (magnitude >= 0) return vec.copy();
    return vec.copy().sub(n_.copy().mult(2*magnitude));
  }
  
  
  PVector refract(PVector vec){
    // n2/n1 = v1/v2 = sinTheta1/sinTheta2
    float magnitude = vec.mag();
    vec.normalize();
    
    float dot = PVector.dot(normal.copy().mult(-1), vec);
    float refrac = dot < 0 ? 1/parent.refractiveIndex : parent.refractiveIndex;
    //float theta1 = dot < 0 ? PI - PVector.angleBetween(vec, normal) : PVector.angleBetween(vec, normal);
    
    
    //float sinTheta2 = sin(theta1) * refrac;
    //if (sinTheta2 >= 1) return reflect(vec, normal.copy().mult(-1));
    //float theta2 = asin(sinTheta2);
    
    PVector output = vec.copy();
    output.mult(refrac);
    /*
    PVector deflectionVector = normal.copy();
    float deflectionFactor = sqrt(1 - refrac*refrac*(1-dot*dot)) - refrac*dot;
    deflectionVector.mult(deflectionFactor);
    output.add(deflectionVector);
    output.mult(magnitude);*/
    return output;
  }
}
