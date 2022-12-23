class Node extends Transform{
  PVector attraction;
  Node parent;
  float thickness;
  Node(float x_, float y_, Node parent_){
    super(x_,y_);
    attraction = new PVector(0,0);
    parent = parent_;
    thickness = minThickness;
  }
  
  void attract(Auxin a){
    PVector displacement = new PVector(a.x-x,a.y-y);
    attraction.add(displacement);
  }
  
  void grow(ArrayList<Node> nodes, Quadtree<Node> qTree){
    if (attraction.mag() <= 0 || attraction == new PVector(0,0)) return;
    attraction.add(PVector.random2D().mult(max(attraction.mag()*roughness, 1)));
    attraction.normalize().mult(growthDist);
    
    Node newN = new Node(x+attraction.x, y+attraction.y, this);
    nodes.add(newN);
    qTree.insert(newN);
    thicken();
  }
  
  void thicken(){
    if (thicknessIncrement <= 0) return;
    thickness += thicknessIncrement;
    if (parent == null || thickness >= maxThickness || parent.thickness >= thickness+thicknessIncrement) return;
    parent.thicken();
  }
  
  void show(color col){
    fill(col); noStroke();
    circle(x,y,thickness);
  }
}
