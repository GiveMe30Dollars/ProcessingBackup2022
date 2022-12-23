// DELAUNAY CLASS AND BOWYER_WATSON ALGORITHM

float worldMargin = -400;    // LEEWAY WITH REAL PLACING OF SUPERTRIANGLE. THIS SHOULD HAVE NO EFFECT ON THE CIRCUMCIRCLE HANDLING. NOT A POSITIVE NUMBER.

class DelaunaySystem{
  ArrayList<DVertex> vertices;
  ArrayList<DTriangle> triangles;

  DelaunaySystem(){
    vertices = new ArrayList<DVertex>();
    triangles = new ArrayList<DTriangle>();
    
    DVertex superA = new DVertex(-width+worldMargin, -0+worldMargin, true);
    DVertex superB = new DVertex(width*2-worldMargin, 0+worldMargin, true);
    DVertex superC = new DVertex(width/2, height*2-worldMargin, true);
    
    DTriangle supertriangle = new DTriangle(superA, superB, superC);
    
    vertices.add(superA); vertices.add(superB); vertices.add(superC); 
    triangles.add(supertriangle);
  }
  
  <T extends Transform> DelaunaySystem(ArrayList<T> toBeInserted){
    vertices = new ArrayList<DVertex>();
    triangles = new ArrayList<DTriangle>();
    
    DVertex superA = new DVertex(-width+worldMargin, -0+worldMargin, true);
    DVertex superB = new DVertex(width*2-worldMargin, 0+worldMargin, true);
    DVertex superC = new DVertex(width/2, height*2-worldMargin, true);
    
    DTriangle supertriangle = new DTriangle(superA, superB, superC);
    
    vertices.add(superA); vertices.add(superB); vertices.add(superC); 
    triangles.add(supertriangle);
    
    for (T t : toBeInserted){
      add(convertToDVertex((Transform)t));
    }
  }
  
  
  void add(DVertex vertex){    // BOWYER-WATSON ALGORITHM PROPER
    vertices.add(vertex);
    
    ArrayList<DTriangle> badTriangles = new ArrayList<DTriangle>();    // STORE BAD TRIANGLES FOR DELETION. TRIANGLE CONSIDERED BAD IF NEW VERTEX IS IN CIRCUMCIRCLE.
    for (DTriangle triangle : triangles){
      if (triangle.isInCircumcircle(vertex)) badTriangles.add(triangle);
    }
    
    ArrayList<DLine> polygonalHole = new ArrayList<DLine>();    // STORES EDGES OF HOLE FORMED BY BAD TRIANGLE REMOVAL.
    for (DTriangle badTriangle : badTriangles){
      for (DLine candidate : badTriangle.edges){    // FOR EVERY EDGE OF EVERY BAD TRIANGLE
        boolean isValid = true;    // ASSUME EDGE IS VALID. IF DUPLICATE EDGE IS FOUND IN EXISTING HOLE, INVALIDATE AND REMOVE OFFENDERS
        for (DLine existingEdge : polygonalHole){
          if (isCongruent(candidate, existingEdge)){
            isValid = false;
            polygonalHole.remove(polygonalHole.indexOf(existingEdge));
            break;
          }
        }
        if (isValid){
          polygonalHole.add(candidate);
        }
      }
    }
    
    for (DTriangle badTriangle : badTriangles){    // REMOVES BAD TRIANGLES
      triangles.remove(triangles.indexOf(badTriangle));
    }
    
    for (DLine edge : polygonalHole){    // RETRIANGULATES USING EDGES OF HOLE AND VERTEX
      triangles.add(new DTriangle(edge.a, edge.b, vertex));
    }
  }
  void add(float x, float y){
    add(new DVertex(x,y));
  }
  
  
  ArrayList<DVertex> finiteVertices(){
    ArrayList<DVertex> output = new ArrayList<DVertex>();
    for (DVertex v : vertices){
      if (!v.isInfinite) output.add(v);
    }
    return output;
  }
  
  ArrayList<DTriangle> finiteTriangles(){
    ArrayList<DTriangle> output = new ArrayList<DTriangle>();
    for (DTriangle triangle : triangles){
      if (!triangle.hasInfiniteVertex()) output.add(triangle);
    }
    return output;
  }
  
  void show(){
    //for (DTriangle triangle : triangles){
    for (DTriangle triangle : finiteTriangles()){
      triangle.show();
    }
  }
  
  void show(PGraphics pg){
    //for (DTriangle triangle : triangles){
    for (DTriangle triangle : finiteTriangles()){
      triangle.show(pg);
    }
  }
}




// SUPPORT CLASSES

class DVertex extends Transform{    // WILL NEVER INTERACT WITH QUADTREE, THEREFORE DOES NOT INTERACT WITH TRANSFORM
  boolean isInfinite = false;
  DVertex(float x_, float y_){
    super(x_,y_);
  }
  DVertex(float x_, float y_, boolean isInfinite_){
    super(x_,y_);
    isInfinite = isInfinite_;
  }
}
DVertex convertToDVertex(Transform t){
  DVertex output = new DVertex(t.x,t.y,false);
  t.ref = output;
  return output;
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
  int infiniteVerticesValue(){
    if (a.isInfinite && b.isInfinite) return 2;
    if (a.isInfinite || b.isInfinite) return 1;
    return 0;
  }
}
boolean isCongruent(DLine l1, DLine l2){
  return (l1.a == l2.a && l1.b == l2.b) || (l1.b == l2.a && l1.a == l2.b);
}


class DTriangle{    // IMPORTANT INFO AND FUNCTIONS SUCH AS CIRCUMCIRCLE AND INFINITE VERTICES HANDLING
  DVertex a,b,c;
  ArrayList<DLine> edges;
  DVertex circumcenter;
  ArrayList<DVertex> finiteVertices;
  ArrayList<DVertex> infiniteVertices;
  float circumradiusSq;
  
  DTriangle(DVertex a_, DVertex b_, DVertex c_){
    a = a_;
    b = b_;
    c = c_;
    edges = new ArrayList<DLine>();
    edges.add(new DLine(a,b));
    edges.add(new DLine(b,c));
    edges.add(new DLine(c,a));
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
    noFill(); stroke(255); strokeWeight(1.5);
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
