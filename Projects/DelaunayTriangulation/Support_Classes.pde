class DVertex{    // WILL NEVER INTERACT WITH QUADTREE, THEREFORE DOES NOT INTERACT WITH TRANSFORM
  float x, y;
  boolean isInfinite = false;
  DVertex(float x_, float y_){
    x = x_; y = y_;
  }
  DVertex(float x_, float y_, boolean isInfinite_){
    x = x_; y = y_;
    isInfinite = isInfinite_;
  }
}
DVertex convertToDVertex(Transform t){
  return new DVertex(t.x,t.y,false);
}
ArrayList<DVertex> convertToDVertex(ArrayList<Transform> list){
  ArrayList<DVertex> output = new ArrayList<DVertex>();
  for (Transform t : list){
    output.add(convertToDVertex(t));
  }
  return output;
}


class DLine{    // THIS IS ONLY USED TO STORE THE POLYGONAL HOLE DURING BOWYER-WATSON. DTRIANGLE WORKS WITHOUT IT
  DVertex a;
  DVertex b;
  DLine(DVertex a_, DVertex b_){
    a = a_;
    b = b_;
  }
}
boolean isCongruent(DLine l1, DLine l2){
  return (l1.a == l2.a && l1.b == l2.b) || (l1.b == l2.a && l1.a == l2.b);
}


class DTriangle{    // IMPORTANT INFO AND FUNCTIONS SUCH AS CIRCUMCIRCLE AND INFINITE VERTICES HANDLING
  DVertex a,b,c;
  ArrayList<DLine> lines;
  DVertex circumcenter;
  ArrayList<DVertex> finiteVertices;
  ArrayList<DVertex> infiniteVertices;
  float circumradiusSq;
  
  DTriangle(DVertex a_, DVertex b_, DVertex c_){
    a = a_;
    b = b_;
    c = c_;
    lines = new ArrayList<DLine>();
    lines.add(new DLine(a,b));
    lines.add(new DLine(b,c));
    lines.add(new DLine(c,a));
    finiteVertices = new ArrayList<DVertex>();
    infiniteVertices = new ArrayList<DVertex>();
    
    if (a.isInfinite) infiniteVertices.add(a);
    else finiteVertices.add(a);
    if (b.isInfinite) infiniteVertices.add(b);
    else finiteVertices.add(b);
    if (c.isInfinite) infiniteVertices.add(c);
    else finiteVertices.add(c);
    
    calculateCircumcenter();
  }
  
  boolean hasVertex(DVertex candidate){
    return (candidate == a || candidate == b || candidate == c);
  }
  boolean hasInfiniteVertex(){
    return (a.isInfinite || b.isInfinite || c.isInfinite);
  }
  
  void calculateCircumcenter(){
    float ad = a.x * a.x + a.y * a.y;
    float bd = b.x * b.x + b.y * b.y;
    float cd = c.x * c.x + c.y * c.y;
    float D = 2 * ( a.x*(b.y-c.y) + b.x*(c.y-a.y) + c.x*(a.y-b.y) );
    float circumcenterX = 1 / D * ( ad*(b.y-c.y) + bd*(c.y-a.y) + cd*(a.y-b.y) );
    float circumcenterY = 1 / D * ( ad*(c.x-b.x) + bd*(a.x-c.x) + cd*(b.x-a.x) );
    circumcenter = new DVertex(circumcenterX, circumcenterY);
    if (infiniteVertices.size() >= 1) circumcenter.isInfinite = true;
    
    circumradiusSq = pow(circumcenter.x-a.x, 2) + pow(circumcenter.y-a.y, 2);
  }
  
  
  boolean isInCircumcircle(DVertex candidate){
    switch (infiniteVertices.size()){
      case 0:
        float distanceSq = pow(circumcenter.x-candidate.x, 2) + pow(circumcenter.y-candidate.y, 2);
        return (distanceSq < circumradiusSq);
      case 1:
        DVertex a = finiteVertices.get(0);
        DVertex b = finiteVertices.get(1);
        DVertex inf = infiniteVertices.get(0);
        Line l1 = new Line(a.x, a.y, b.x, b.y);
        return (l1.sideOfLine(candidate.x, candidate.y) == l1.sideOfLine(inf.x, inf.y));
      case 2:
        DVertex infA = infiniteVertices.get(0);
        DVertex infB = infiniteVertices.get(1);
        DVertex c = finiteVertices.get(0);
        Float m = (infB.y-infA.y) / (infB.x-infA.x);
        Line l2 = new Line(c.x, c.y, m);
        return (l2.sideOfLine(candidate.x, candidate.y) == l2.sideOfLine(infA.x, infA.y));
      case 3:
        return true;
      default:
        return false;
    }
  }
  
  void show(){
    strokeCap(SQUARE);
    //if(!hasInfiniteVertex()){ fill(255); stroke(0); strokeWeight(3);}
    //else {noFill(); stroke(255); strokeWeight(1);}
    noFill(); stroke(255); strokeWeight(2);
    //fill(128); noStroke();
    /*
    beginShape();
    vertex(a.x,a.y);
    vertex(b.x,b.y);
    vertex(c.x,c.y);
    endShape(CLOSE);*/
    
    line(a.x,a.y,b.x,b.y);
    line(b.x,b.y,c.x,c.y);
    line(c.x,c.y,a.x,a.y);
  }
  
  void show(PGraphics pg){
    strokeCap(SQUARE);
    //if(!hasInfiniteVertex()){ fill(255); stroke(0); strokeWeight(3);}
    //else {noFill(); stroke(255); strokeWeight(1);}
    //noFill(); stroke(255); strokeWeight(2);
    fill(255); noStroke();
    
    beginShape();
    vertex(a.x,a.y);
    vertex(b.x,b.y);
    vertex(c.x,c.y);
    endShape(CLOSE);
    /*
    pg.line(a.x,a.y,b.x,b.y);
    pg.line(b.x,b.y,c.x,c.y);
    pg.line(c.x,c.y,a.x,a.y);*/
  }
}
