class Tree{
  ArrayList<Node> nodes;
  ArrayList<Auxin> auxins;
  Quadtree<Node> qTree;
  
  Tree(){
    nodes = new ArrayList<Node>();
    auxins = new ArrayList<Auxin>();
    qTree = new Quadtree<Node>(50);
    qTree.insert(nodes);
  }
  
  void addAuxin(float x, float y){
    auxins.add(new Auxin(x,y));
  }
  void addNode(float x, float y){
    Node n = new Node(x,y,null);
    nodes.add(n);
    qTree.insert(n);
  }
  
  void update(String type){
    if (auxins.size() <= 0 || nodes.size() <= 0) return;
    // CLEAR DATA
    for (Auxin a : auxins){
      a.attracted = new ArrayList<Node>();
    }
    for (Node n : nodes){
      n.attraction = new PVector(0,0);
    }
    // CHECK FOR APPROPRIATE ATTRACTED
    for (Auxin a : auxins){
      a.attract(qTree, type);
    }
    // GROW NEW NODES
    for (int i = nodes.size()-1; i >= 0; i--){
      nodes.get(i).grow(nodes, qTree);
    }
    // REMOVE AUXIN
    for (int i = auxins.size()-1; i >= 0; i--){
      auxins.get(i).attempt(auxins);
    }
  }
  
  
  
  
  void show(){
    
    for (Auxin a : auxins){
      noStroke(); fill(#00ff99);
      //noStroke(); fill(255,255,255,32);
      circle(a.x,a.y,3);
      /*
      noFill(); stroke(255,255,255,32); strokeWeight(1);
      for (Node n : a.attracted){
        line(a.x,a.y,n.x,n.y);
      }*/
    }
    
    for (Node n : nodes){
      n.show(color(255,255,255));
    }
    
  }
}
