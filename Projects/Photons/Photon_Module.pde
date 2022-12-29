import java.util.*;

float collisionThreshold = 0.001;

class Photon extends Transform{
  
  PVector velocity;
  
  Photon(float x_, float y_, PVector vel_){
    super(x_,y_);
    velocity = vel_;
  }
  
  void update(ArrayList<Collider> colliders){
    update(colliders, velocity.copy());
  }
  
  void update(ArrayList<Collider> colliders, PVector displacement){
    if (displacement.mag() < collisionThreshold) return;    // TERMINATE IF DISPLACEMENT IS INFINESTIMALLY SMALL
    
    Segment path = new Segment(x, y, x+displacement.x ,y+displacement.y);    // GENERATE LINE SEGMENT OF PATH,
    ColliderEdge edge = collisionCheck(colliders, path);    // CHECK FOR COLLISION AGAINST EVERY COLLIDEREDGE
    if (edge == null){    // IF NO COLLISIONS, MOVE AND RETURN
      move(displacement);
      return;
    }
    PVector collisionPoint = intersects(edge, path);  // ELSE, MOVE TO COLLISION POINT
    x = collisionPoint.x;
    y = collisionPoint.y;
    
    // AND CALCULATE REMAINING PENDING DISPLACEMENT
    PVector remainingDIS = new PVector(x+displacement.x - collisionPoint.x, y+displacement.y - collisionPoint.y);
    PVector alteredDIS = edge.collisionResponse(remainingDIS);
    
    velocity = alteredDIS.copy().normalize().mult(velocity.mag());
    
    // EXECUTE RECURSIVELY WITH PENDING DISPLACEMENT
    update(colliders, alteredDIS);
  }
  
  // BASED ON DISPLACEMENT, RETURN MOST RECENT COLLISION WITH ANY COLLIDER
  ColliderEdge collisionCheck(ArrayList<Collider> colliders, Segment path){
    TreeMap<Float, ColliderEdge> collisionQueue = new TreeMap<Float, ColliderEdge>();
    for (Collider col : colliders){
      for (ColliderEdge edge : col.edges){
        PVector intersection = intersects(path, edge);
        if (intersection == null) continue;
        float distanceSqr = distSqr(x,y,intersection.x,intersection.y);
        collisionQueue.put(distanceSqr, edge);
      }
    }
    for (Map.Entry<Float, ColliderEdge> entry : collisionQueue.entrySet()){
      if (entry.getKey() <= collisionThreshold) continue;
      return entry.getValue();
    }
    return null;
  }
  
  void move(PVector displacement){
    x += displacement.x;
    y += displacement.y;
  }

  void show(color fillCol, color strokeCol, float weight, float radius){
    fill(fillCol); stroke(strokeCol); strokeWeight(weight);
    circle(x,y, radius);
  }
  void show(){
    show(color(255,200,128, 128), color(255,255,255,0), 0, 2);
  }
}



float distSqr(float x1, float y1, float x2, float y2){
  return pow(x2-x1,2) + pow(y2-y1,2);
}
