class VerletSystem <TPoint extends Point, TStick extends Stick>{
  ArrayList<TPoint> points;
  ArrayList<TStick> sticks;
  VerletSystem(){
    points = new ArrayList<TPoint>();
    sticks = new ArrayList<TStick>();
  }
  
  // ----- ADD SINGULAR COMPONENT-----
  
  void addPoint(TPoint p){
    points.add(p);
  }
  void addStick(TStick s){
    sticks.add(s);
  }
  void addStick(TPoint p1, TPoint p2, boolean isVisible){
    sticks.add((TStick)new Stick(p1,p2, isVisible));
  }
  void addStick(int i1, int i2, boolean isVisible){
    Point p1 = points.get(i1);
    Point p2 = points.get(i2);
    sticks.add((TStick)new Stick(p1,p2,isVisible));
  }
  void addStick(int i1, int i2){
    Point p1 = points.get(i1);
    Point p2 = points.get(i2);
    sticks.add((TStick)new Stick(p1,p2));
  }
  
  
  // -----ADD LIST OF COMPONENTS-----
  
  void addPoint(ArrayList<TPoint> pArray){
    for (TPoint p : pArray) points.add(p);
  }
  void addStick(ArrayList<TStick> sArray){
    for (TStick s : sArray) sticks.add(s);
  }
  
  void update(int stickUpdates){
    for (TPoint p : points){
      p.update();
    }
    for (int i = 0; i < stickUpdates; i++){
      for (TStick s : sticks){
        s.update();
      }
      for (TPoint p : points){
      p.constrain();
      }
    }
  }
  void update(){
    update(3);
  }
  
  void show(){
    for (TPoint p : points){
      p.show();
    }
    for (TStick s : sticks){
      s.show();
    }
  }
}
