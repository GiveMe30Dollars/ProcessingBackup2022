float worldMargin = -40;    // LEEWAY WITH REAL PLACING OF SUPERTRIANGLE. THIS SHOULD HAVE NO EFFECT ON THE CIRCUMCIRCLE HANDLING. NOT A POSITIVE NUMBER.

class DelaunaySystem{
  ArrayList<DVertex> vertices;
  ArrayList<DTriangle> triangles;

  DelaunaySystem(){
    vertices = new ArrayList<DVertex>();
    triangles = new ArrayList<DTriangle>();
    
    DVertex superA = new DVertex(0+worldMargin, 0+worldMargin, true);
    DVertex superB = new DVertex(width*2-worldMargin, 0+worldMargin, true);
    DVertex superC = new DVertex(0+worldMargin, height*2-worldMargin, true);
    
    DTriangle supertriangle = new DTriangle(superA, superB, superC);
    
    vertices.add(superA); vertices.add(superB); vertices.add(superC); 
    triangles.add(supertriangle);
  }/*
  DelaunaySystem(ArrayList<DVertex> toBeInserted){
    vertices = new ArrayList<DVertex>();
    triangles = new ArrayList<DTriangle>();
    
    DVertex superA = new DVertex(0+worldMargin, 0+worldMargin, true);
    DVertex superB = new DVertex(width*2-worldMargin, 0+worldMargin, true);
    DVertex superC = new DVertex(0+worldMargin, height*2-worldMargin, true);
    
    DTriangle supertriangle = new DTriangle(superA, superB, superC);
    
    vertices.add(superA); vertices.add(superB); vertices.add(superC); 
    triangles.add(supertriangle);
    
    for (DVertex v : toBeInserted){
      add(v);
    }
  }*/
  <T extends Transform>DelaunaySystem(ArrayList<T> toBeInserted){
    vertices = new ArrayList<DVertex>();
    triangles = new ArrayList<DTriangle>();
    
    DVertex superA = new DVertex(0+worldMargin, 0+worldMargin, true);
    DVertex superB = new DVertex(width*2-worldMargin, 0+worldMargin, true);
    DVertex superC = new DVertex(0+worldMargin, height*2-worldMargin, true);
    
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
      for (DLine candidate : badTriangle.lines){    // FOR EVERY EDGE OF EVERY BAD TRIANGLE
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
