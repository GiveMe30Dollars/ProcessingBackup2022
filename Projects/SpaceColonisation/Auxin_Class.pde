class Auxin extends Transform{
  ArrayList<Node> attracted;
  Auxin(float x_, float y_){
    super(x_,y_);
    //attracted = new ArrayList<Node>();
  }
  
  void attract(Quadtree<Node> qTree, String type){
    Circle c = new Circle(x,y,maxRadius);
    ArrayList<Node> potentialNodes = qTree.query(c);
    Node candidate;
    
    switch(type){
      
      case "OPEN":    // FIND NEAREST NEIGHBOUR
        candidate = null;
        float nearestDistSQ = Float.POSITIVE_INFINITY;
        for (Node n : potentialNodes){
          if (distSQ(this,n) < nearestDistSQ){
            candidate = n;
            nearestDistSQ = distSQ(this,n);
          }
        }
        if (candidate == null) return;
        candidate.attract(this);
        attracted.add(candidate);
        return;
        
      case "CLOSED":    // FIND RELATIVE NEIGHBOURS
        ArrayList<Node> candidates = (ArrayList<Node>) potentialNodes.clone();
        for (int i = candidates.size()-1; i >= 0; i--){
          candidate = candidates.get(i);
          float distCandidateSQ = distSQ(this, candidate);
          for (Node other : potentialNodes){     // IF ANY OTHER NODE IS CLOSER TO BOTH THIS AND CANDIDATE, DISQUALIFY CANDIDATE
            if (other == candidate) continue;
            if (distSQ(this,other) < distCandidateSQ && distSQ(candidate,other) < distCandidateSQ){
              candidates.remove(candidates.indexOf(candidate));
              break;
            }
          }
        }
        if (candidates.size() <= 0) return;
        for (int i = candidates.size()-1; i >= 0; i--){
          Node n = candidates.get(i);
          if (distSQ(this,n) < killDist*killDist){
            //candidates.remove(candidates.indexOf(n));
            continue;
          }
          n.attract(this);
        }
        attracted = candidates;
        return;
       
    }
  }
  
  void attempt(ArrayList<Auxin> auxins){
    if (attracted.size() <= 0) return;
    for (Node n : attracted){
      float distSQ = distSQ(this,n);
      /*
      if (distSQ < killDist*killDist){    // KILL IF ANY ATTRACTED NODES REACH KIL RADIUS
        auxins.remove(auxins.indexOf(this));
        return;
      }*/
      if (distSQ > killDist*killDist) return;    // KILL ONLY IF ALL ATTRACTED NODES ARE WITHIN RADIUS
    }
    auxins.remove(auxins.indexOf(this));    // ALL NODES REQUIRED, PART 2
  }
}



float distSQ(Transform a, Transform b){
  return pow(a.x-b.x,2) + pow(a.y-b.y,2);
}
