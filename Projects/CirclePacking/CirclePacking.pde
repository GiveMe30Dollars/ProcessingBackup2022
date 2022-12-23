float collisionMultiplier = 5;
float borderMultiplier = 2;

float damping = 0.01;
float maxSpeed = 1;

PackingSystem sys;
VoronoiSystem v;

void setup(){
  size(2000,2000);
  background(0);
  sys = new PackingSystem();
  background(0);
  for (int  i = 0; i < 2000; i++){
    sys.addCircle(random(20)-10+width/2, random(20)-10+height/2, 40, 0.5);
    //sys.addCircle(random(20)-10+width/2, random(20)-10+height/2, 7, 0.2+abs(randomGaussian()*5));
  }
  //recordStart(900,"Exports/Diagonal.mp4",60);
}

void draw(){
  background(0);
  //PImage canvas = get();
  //noTint();
  //tint(230,200,50,200);
  //image(canvas,0,0);
  //if (frameCount % 5 == 0 && frameCount < 100) 
  sys.update(2);
  //sys.show();
  v = new VoronoiSystem(sys.circles);
  v.generate();
  //v.show();
  
  for (VCell cell : v.cells){
    Polygon p = cell.clipped();
    p.scale(max(1f-(float)frameCount/700f,0.1));
    p.chaikinCurve(0.15,3,50);
    p.show(#ffffff,#ffffff,0,true);
  }
  noTint();
  filter(INVERT);
  diagnostics();
  //if (frameCount == 1000) save("Exports/Pics/Xcell2.png");
  //recordUpdate();
}

float domainWarping(float x, float y){
  //PVector displacement = PVector.fromAngle(noise(x*0.02+y*0.01)*TWO_PI).mult(noise(y*0.01+1000,x*0.01-1000)*2);
  //PVector displacement = new PVector(noise(x*0.01+5000,y*0.01),noise(y*0.01+1000,x*0.01-1000)).mult(5);
  PVector displacement = PVector.fromAngle(noise(x*0.01,y*0.01)*TWO_PI).mult(2);
  return noise(x*0.01+displacement.x+y*0.01+displacement.y);
}

void mouseClicked(){
  save("Exports/Pics/VCells.png");
}
