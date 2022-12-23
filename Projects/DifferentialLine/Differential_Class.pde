class Differential{
  float x; float y;
  ArrayList<Node> nodes;
  ArrayList<Edge> edges;
  
  Differential(float x_, float y_, String mode, float len, int num){
    x = x_; y = y_;
    nodes = new ArrayList<Node>();
    edges = new ArrayList<Edge>();
    
    switch (mode){
      case "CIRCLE":
        startCircle(len, num); break;
      case "LINE":
        startLine(len, num); break;
      case "MESH":
        startMesh(len, num); break;
    }
  }
  
  
  void startCircle(float len, int num){
    Node initial = new Node(x+len, y);
    nodes.add(initial);
    for (float i = 1; i < num; i++){
      PVector displacement = PVector.fromAngle(i/(float)num*TWO_PI).mult(len);
      Node n = new Node(x+displacement.x, y+displacement.y);
      nodes.add(n);
      Node prev = nodes.get((int)i-1);
      edges.add(new Edge(prev, n));
    }
    Node end = nodes.get(num-1);
    edges.add(new Edge(initial, end));
  }
  void startLine(float len, int num){
    Node initial = new Node(x-len/2f, y);
    nodes.add(initial);
    for (float i = 1; i < num; i++){
      float percent = i/(float)num;
      PVector displacement = new PVector(lerp(-len/2f, len/2f, percent), random(1));
      Node n = new Node(x+displacement.x, y+displacement.y);
      nodes.add(n);
      Node prev = nodes.get((int)i-1);
      edges.add(new Edge(prev, n));
    }
  }
  void startMesh(float len, int num){
    for (float j = 0; j < num; j++){
      for (float i = 0; i < num; i++){
        float percentX = i/(float)num;
        float percentY = j/(float)num;
        PVector displacement = new PVector(lerp(-len/2f, len/2f, percentX), lerp(-len/2f, len/2f, percentY));
        Node n = new Node(x+displacement.x, y+displacement.y);
        nodes.add(n);
        if (i != 0){
          Node prev = nodes.get(nodes.size()-2);
          edges.add(new Edge(prev, n));
        }
        if (j != 0){
          Node prev = nodes.get(nodes.size()-num-1);
          edges.add(new Edge(prev, n));
        }
      }
    }
  }
  
  
  void update(float rejectionRadius, float rejectionMultiplier, float splitLength, float attractionMultiplier, float attractionLimit){
    Quadtree<Node> qTree = new Quadtree(0, 0, width, height, 5);
    
    qTree.insert(nodes);
    for(Node n : nodes){
      n.repel(qTree, rejectionRadius, rejectionMultiplier);
    }
    
    for(int i = edges.size()-1; i >= 0; i--){
      Edge e = edges.get(i);
      if (e.lenSquared() < pow(splitLength,2)){
        e.n1.attract(e.n2, attractionMultiplier, attractionLimit);
        e.n2.attract(e.n1, attractionMultiplier, attractionLimit);
        continue;
      }
      splitEdge(i);
    }
    
    for(int j = 0; j < 5; j++){
      int i = (int)random(edges.size());
      splitEdge(i);
    }
    
    for(Node n : nodes){
      n.update();
    }
  }
  
  void splitEdge(int i){
    Edge e = edges.get(i);
    Node splitNode = new Node((e.n1.x+e.n2.x)/2, (e.n1.y+e.n2.y)/2);
    nodes.add(splitNode);
    edges.add(new Edge(e.n1, splitNode));
    edges.add(new Edge(splitNode, e.n2));
    edges.remove(i);
  }
  
  void show(){
    //for(Node n : nodes){ n.show(); }
    for(Edge e : edges){ e.show(); }
  }
  
  void debugShow(){
    for(Node n : nodes){ n.debugShow(); }
    for(Edge e : edges){ e.debugShow(); }
  }
}
