import java.util.*;

class Cloth extends VerletSystem{
  Cloth(int w, int h, float size, int pinNumber, float elasticity){
    super();
    
    Point prev = null;    // STORE PREVIOUS POINT
    int yIndex = 0;    // KEEPING TRACK OF INDEX, FOR LOOP CALCULATES POSITION
    for (float y = 10; y < 10 + h*size; y += size){
      int xIndex = 0;
      for (float x = width/2 - w*size/2; x < width/2 + w*size/2; x += size){
        
        Point p = new Point(x,y);    // MAKE POINT
        addPoint(p);
        int index = yIndex * w + xIndex;
        
        if (x != width/2 - w*size/2){    // IF NOT ON LEFT EDGE, CONNECT WITH PREVIOUS POINT
          Elastick e = new Elastick(p, prev, distance(p,prev), elasticity);
          addStick(e);
        }
        if (y != 10){    // IF NOT ON TOP EDGE, CONNECT WITH POINT ABOVE
          Point pAbove = (Point)points.get(index-w);
          Elastick e = new Elastick(p, pAbove, distance(p,pAbove), elasticity);
          addStick(e);
        }
        
        prev = p;
        xIndex++;
      }
      yIndex++;
    }
    
    for (float i = 0; i <= w; i += w/(pinNumber-1)){    // FIND NUMBER OF PINS REQUIRED
      if (pinNumber == 0) break;
      int xIndex = round(i);
      Point p = (Point)points.get(xIndex);
      p.pinned = true;
    }
    
    Collections.shuffle(sticks);    // TO PREVENT ORDER BIAS
  }
  
  void wind(){
    for (int i = 0; i < points.size(); i++){
      Point p = (Point)points.get(i);
      if (p.pinned && mouseButton == LEFT) continue;    // NO MOVEMENT IF PINNED AND LEFT CLICK USED
      
      PVector windDir = new PVector(p.x - mouseX, p.y - mouseY);    // GET DIRECTION OF POINT FROM MOUSE
      float magnitude = min(150/windDir.mag(), 15);    // GET MAGNITUDE OF FORCE BASED ON DISTANCE TO MOUSE
      if (mouseButton == RIGHT) magnitude *= -1.5;    // FLIPS. IF LEFT CLICK, REPELS. IF RIGHT CLICK, ATTRACTS
      windDir.normalize();
      
      p.x += windDir.x * magnitude;
      p.y += windDir.y * magnitude;
    }
  }
  
  <T extends Line>void cut(T cuttingLine){
    if (cuttingLine.length() < 0.0001) return;
    
    for(int i = 0; i < sticks.size(); i++){
      Elastick e = (Elastick)sticks.get(i);
      LineSegment stick = new LineSegment(e.p1.x, e.p1.y, e.p2.x, e.p2.y);
      if (intersects(cuttingLine, stick) == null) continue;
      sticks.remove(i);
    }
  }
  
  void decimate(float percent){
    int numberOfDecimated = ceil((float)sticks.size() * percent);
    for(int i = 0; i < numberOfDecimated; i++){
      if (sticks.size() <= 0) return;
      int index = floor(random(sticks.size()));
      sticks.remove(index);
    }
  }
}
