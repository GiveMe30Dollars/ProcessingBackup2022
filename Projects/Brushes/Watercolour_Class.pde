float maxW = 3;


class Transform{
  float x;
  float y;
  Transform(float x_, float y_){
    x = x_;
    y = y_;
  }
  void show(){}
  void update(){}
}

class WatercolourData implements Cloneable{    // GLORIFIED POLYGON, WITH EXTRAS
  ArrayList<Transform> points;
  ArrayList<Float> weights;
  WatercolourData(ArrayList<Transform>points_, ArrayList<Float>weights_){
    points = points_;
    weights = weights_;
  }
  WatercolourData(){
    points = new ArrayList<Transform>();
    weights = new ArrayList<Float>();
  }
  
  public Object clone() throws CloneNotSupportedException{    // FOR CLONING, JUST IN CASE
   return super.clone(); 
  }
  
  void show(color col){
    fill(col); noStroke();
    beginShape();
    for (int i = 0; i < points.size(); i++){
      Transform t = points.get(i);
      vertex(t.x,t.y);
      //circle(t.x,t.y,5);
    }
    endShape();
  }
}

class Watercolour{
  WatercolourData seed;
  WatercolourData base;
  float sdPosition = 0.3;
  float sdMagnitude = 0.3;
  float sdVariation = 0.05;
  Watercolour(ArrayList<Transform> points_){
    ArrayList<Float> weights = new ArrayList<Float>();
    for (int i = 0; i < points_.size(); i++){
      weights.add(1f);
    }
    seed = new WatercolourData(points_, weights);
  }
  Watercolour(ArrayList<Transform> points_, ArrayList<Float> weights_){
    seed = new WatercolourData(points_, weights_);
  }
  Watercolour(float radius, int num){
    ArrayList<Transform> points = new ArrayList<Transform>();
    for (float i = 0; i < TWO_PI; i += TWO_PI/(float)num){
      float x = radius*cos(i) + width/2;
      float y = radius*sin(i) + height/2;
      points.add(new Transform(x,y));
    }
    ArrayList<Float> weights = new ArrayList<Float>();
    for (int i = 0; i < points.size(); i++){
      weights.add(1f);
    }
    seed = new WatercolourData(points, weights);
  }
  
  WatercolourData distort(WatercolourData data){    // DISTORT POLYGON FOR MORE DETAIL
    ArrayList<Transform> newPoints = new ArrayList<Transform>();
    ArrayList<Float> newWeights = new ArrayList<Float>();
    for (int i = 0; i < data.points.size(); i++){    // FOR EACH EDGE, SPLIT. NEW POINT DEPENDS ON GAUSSIAN NOISE
      
      Transform p1 = data.points.get(i);
      Transform p2 = data.points.get((i+1) % data.points.size());
      float w = data.weights.get(i);
      
      PVector tangent = new PVector(p2.x-p1.x, p2.y-p1.y).rotate(-HALF_PI);
      tangent.mult(abs(randomGaussian()*sdMagnitude*w));
      
      float newPointValue = (sdPosition*randomGaussian())+0.5;
      if (newPointValue < 0) newPointValue = 0;
      if (newPointValue > 1) newPointValue = 1;
      Transform newP = new Transform(lerp(p1.x,p2.x,newPointValue)+tangent.x,lerp(p1.y,p2.y,newPointValue)+tangent.y);    // POINT TANGENT TO OLD LINE, MAGNITUDE EXTENDING OUTWARDS
      
      float newW1 = w + randomGaussian()*sdVariation;    // MUTATE WEIGHT VALUES: GREATER WEIGHT MEANS MORE DISTORTION
      if (newW1 < 0) newW1 = 0;
      if (newW1 > maxW) newW1 = maxW;
      float newW2 = w + randomGaussian()*sdVariation;
      if (newW2 < 0) newW2 = 0;
      if (newW2 > maxW) newW2 = maxW;
      
      newPoints.add(p1); newPoints.add(newP);
      newWeights.add(newW1); newWeights.add(newW2);
    }
    return new WatercolourData(newPoints, newWeights);
  }
  
  void generateBase(int num){    // FANCYY DISTORTING
    try{
      WatercolourData temp1 = (WatercolourData)seed.clone();
      for (int i = 0; i < num; i++){
        WatercolourData temp2 = distort(temp1);
        temp1 = (WatercolourData)temp2.clone();
      }
      base = temp1;
    }
    catch(CloneNotSupportedException c){ print("WATERCOLOUR DATA CLONING ERROR.");}
  }
  
  void show(color col, int layersNum, int distortNum){
    if (base == null) generateBase(3);
    try{
      for (int n = 0; n < layersNum; n++){
        WatercolourData temp1 = (WatercolourData)base.clone();
        for (int i = 0; i < distortNum; i++){
          WatercolourData temp2 = distort(temp1);
          temp1 = (WatercolourData)temp2.clone();
        }
        temp1.show(col);
      }
    }
    catch(CloneNotSupportedException c){ print("WATERCOLOUR DATA CLONING ERROR.");}
  }
}
