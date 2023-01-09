VoronoiSystem sys;
ArrayList<Transform> obstacleNodes;
int nodeAmount = 50;
float nodeSpawnMargin = 40;

float obstacleClipMargin = 50;
float obstacleScale = 0.8;
float obstacleDensity = 0.9;

float chaikinCurvePercentage = 0.25;
int chaikinCurveNumber = 2;

ArrayList<Collider> generateVoronoiColliders(){
  ArrayList<Transform> obstacleNodes = new ArrayList<Transform>();
  for (int i = 0; i < nodeAmount; i++){
    obstacleNodes.add(new Transform(random(width-2*nodeSpawnMargin)+nodeSpawnMargin, random(height-2*nodeSpawnMargin)+nodeSpawnMargin));
  }
  sys = new VoronoiSystem(obstacleNodes);
  sys.generate();
  
  //ArrayList<Collider> output = new ArrayList<Collider>();
  ArrayList<Collider> output = generateSupercollider();
  for (int i = 1; i <= floor(sys.cells.size()*obstacleDensity); i++){
    Polygon p = sys.cells.get(i-1).clipped(obstacleClipMargin);
    //p.scale(obstacleScale);
    p.scale(sqrt(p.centroid.y/height));
    p.chaikinCurve(chaikinCurvePercentage, chaikinCurveNumber);
    Collider col = new Collider(p);
    //col.refractiveIndex = 5;
    //if (col.contains(width/2, height/2)) continue;
    if (col.centroid.y/height < random(1)) continue;
    output.add(col);
  }
  return output;
}

float circleRadius = 250;
float initialPointNumber = 16;
ArrayList<Collider> generateCircleCollider(){
  Polygon pol = new Polygon();
  for (int i = 0; i < initialPointNumber; i++){
    float angle = i/initialPointNumber*TWO_PI;
    PVector circle = PVector.fromAngle(angle).mult(circleRadius);
    Transform node = new Transform(width/2 + circleRadius * cos(angle), height/2 + circleRadius * sin(angle));
    pol.add(node);
  }
  pol.chaikinCurve(chaikinCurvePercentage, chaikinCurveNumber);
  Collider col = new Collider(pol);
  col.refractiveIndex = 1.5;
  ArrayList<Collider> output = new ArrayList<Collider>();
  //ArrayList<Collider> output = generateSupercollider();
  output.add(col);
  return output;
}


ArrayList<Collider> generateSupercollider(){
  Polygon superpolygon = new Polygon();
  superpolygon.add(new Transform(0,0));
  superpolygon.add(new Transform(width,0));
  superpolygon.add(new Transform(width,height));
  superpolygon.add(new Transform(0,height));
  ArrayList<Collider> output = new ArrayList<Collider>();
  output.add(new Collider(superpolygon));
  return output;
}
