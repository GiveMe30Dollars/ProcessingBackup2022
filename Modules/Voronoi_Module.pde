import java.util.*;

class VoronoiSystem extends DelaunaySystem{
  
  ArrayList<VCell> cells;
  
  VoronoiSystem(){
    super();
  }
  <T extends Transform>VoronoiSystem(ArrayList<T> toBeInserted){
    super(toBeInserted);
  }
  
  void generate(){
    
    cells = new ArrayList<VCell>();
    
    for (DVertex site : finiteVertices()){    // FOR EACH FINITE VERTEX, FORM VORONOI CELL WITH IT AS SITE
      
      // FIND CIRCUMCENTERS OF TRIANGLES WHICH HAVE VERTEX
      
      ArrayList<VVertex> circumcenters = new ArrayList<VVertex>();
      for (DTriangle triangle : triangles){
        if (triangle.hasVertex(site)) circumcenters.add(new VVertex(triangle.circumcenter,site));
      }
      
      Collections.sort(circumcenters);
      cells.add(new VCell(site, circumcenters));
    }
  }
  
  ArrayList<VCell> finiteCells(){
    ArrayList<VCell> output = new ArrayList<VCell>();
    for (VCell cell : cells){
      if (!cell.hasInfiniteVertices()) output.add(cell);
    }
    return output;
  }
  
  void show(){
    generate();/*
    for (DTriangle triangle : triangles){
      triangle.show();
    }*/
    for (VCell cell : cells){
      cell.show();
    }/*
    for (DVertex v : vertices){
      fill(255); noStroke();
      circle(v.x,v.y,10);
    }*/
  }
}


class VVertex extends DVertex implements Comparable<VVertex>{
  float angle;
  VVertex(DVertex vertex, DVertex site){
    super(vertex.x, vertex.y, vertex.isInfinite);
    PVector displacement = new PVector( vertex.x - site.x, vertex.y - site.y);
    angle = displacement.heading();
  }
  
  public int compareTo(VVertex other){
    return (int)Math.signum(this.angle - other.angle);
  }
}



class VCell{
  DVertex site;
  ArrayList<VVertex> vertices;
  ArrayList<DLine> edges;
  VCell(DVertex site_, ArrayList<VVertex> v_){
    site = site_;
    vertices = v_;
    edges = new ArrayList<DLine>();
    for (int i = 0; i < vertices.size(); i++){
      edges.add(new DLine( vertices.get(i), vertices.get((i+1)%vertices.size()) ));
    }
  }
  
  boolean hasInfiniteVertices(){
    for (DVertex v : vertices){
      if (v.isInfinite) return true;
    }
    return false;
  }
  
  void show(){
    fill(0); noStroke();
    beginShape();
    for (int i = 0; i < vertices.size(); i++){
      Transform t = vertices.get(i);
      vertex(t.x, t.y);
    }
    endShape(CLOSE);
    noFill(); stroke(255); strokeWeight(3);
    for (int i = 0; i < vertices.size(); i++){
      Transform t1 = vertices.get(i);
      Transform t2 = vertices.get((i+1)%vertices.size());
      line(t1.x, t1.y, t2.x, t2.y);
    }
  }
  
  Polygon unclipped(){
    Polygon output = new Polygon();
    for (int i = 0; i < vertices.size(); i++){
      output.add(vertices.get(i));
    }
    return output;
  }
  Polygon clipped(){
    return clipped(0);
  }
  Polygon clipped(float margin){
    Polygon clippingPolygon = new Polygon();
    clippingPolygon.add(new Transform(0+margin,0+margin));
    clippingPolygon.add(new Transform(0+margin,height-margin));
    clippingPolygon.add(new Transform(width-margin,height-margin));
    clippingPolygon.add(new Transform(width-margin,0+margin));
    Polygon p = unclipped();
    p.clip(clippingPolygon);
    return p;
  }
  Polygon clipped(Polygon clippingPolygon){
    Polygon p = unclipped();
    p.clip(clippingPolygon);
    return p;
  }
}
