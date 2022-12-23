class Quadtree <T extends Transform> extends Rectangle{
  Quadtree childTL;
  Quadtree childTR;
  Quadtree childBL;
  Quadtree childBR;
  boolean divided;
  int capacity;
  ArrayList<T> points;
  Quadtree(float x_, float y_, float w_, float h_, int c_){
    super(x_, y_, w_, h_);
    divided = false;
    capacity = c_;
    points = new ArrayList<T>();
  }
  
  void reset(){
    childTL = null;
    childTR = null;
    childBL = null;
    childBR = null;
    divided = false;
    points = new ArrayList<T>();
  }
  
  void insert(ArrayList<T> array){
    for (T t : array){
      insert(t);
    }
  }
  
  void insert(T t){
    if (!contains(t)) return;
    if (!divided){
      points.add(t);
      if (points.size() <= capacity) return;
      childTL = new Quadtree(x, y, w/2, h/2, capacity);
      childTR = new Quadtree(x+w/2, y, w/2, h/2, capacity);
      childBL = new Quadtree(x, y+h/2, w/2, h/2, capacity);
      childBR = new Quadtree(x+w/2, y+h/2, w/2, h/2, capacity);
      for (T q : points){
        childTL.insert(q);
        childTR.insert(q);
        childBL.insert(q);
        childBR.insert(q);
      }
      points = null;
      divided = true;
      return;
    }
    childTL.insert(t);
    childTR.insert(t);
    childBL.insert(t);
    childBR.insert(t);
  }
  
  
  <T2 extends Geometry> ArrayList<T> query(T2 range){
    ArrayList<T> queryArray = new ArrayList<T>();
    query(range, queryArray);
    return queryArray;
  }
  
  
  <T2 extends Geometry> void query(T2 range, ArrayList<T> queryArray){
    if (!intersects(range)) return;
    if (!divided){
      for (T t : points){
        if (range.contains(t)) queryArray.add(t);
      }
      return;
    }
    childTL.query(range, queryArray);
    childTR.query(range, queryArray);
    childBL.query(range, queryArray);
    childBR.query(range, queryArray);
  }
  
  
  void show(){
    super.show();
    if (!divided){
      for (T p : points){
        p.show();
      }
      return;
    }
    childTL.show();
    childTR.show();
    childBL.show();
    childBR.show();
  }
}
