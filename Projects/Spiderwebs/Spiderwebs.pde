Spiderweb v;

float initialRadius = 750;
float initialNumber = 60;
float elasticity = 0.3;
float sizePercentage = 0.02;


void setup(){
  size(1000,1000);
  background(0);
  v = new Spiderweb(initialRadius, initialNumber, elasticity);
  
  //recordStart(1800,"Exports/AllConnecting.mp4");
}

int framesTilSplit = 3;
Line l;

void draw(){
  PImage canvas = get();
  background(0);
  tint(150,200,150,200);
  image(canvas,0,0);
  
  v.update(10);
  v.show();
  
  if (frameCount % framesTilSplit == 0){
    //l = new Line(random(width), random(height), random(width), random(height));    // TRUE RANDOM
    //l = new Line(random(width/2)+width/4, random(height/2)+height/4, random(width/2)+width/4, random(height/2)+height/4);    // CONSTRAINED RANDOM
    
    // CENTRE LINE
    float x = width/2;// + random(100)-50;
    float y = height/2;// + random(100)-50;
    float angle = random(PI) - HALF_PI;    // RANDOM
    //float angle = (((float)ceil(random(6)))/ 6) * PI - HALF_PI;    // CARDINAL ANGLES
    //float angle = random(2) <= 1 ? 0 : HALF_PI;    // CARTESIAN
    Float m = tan(angle);
    if (angle == HALF_PI || angle == -HALF_PI) m = Float.POSITIVE_INFINITY;
    float c = y - m*x;
    /*
    float x = width/2 + (pow(random(15),2)+50) * (floor(random(2))*2-1);    // TANGENTS
    float y = height/2 + (pow(random(15),2)+50) * (floor(random(2))*2-1);
    float m = (y-height/2)/(x-width/2);
    float tangent = (-1)/m;
    float c = y - tangent*x;*/
    
    l = new Line(x, y, 0, c);
    if (m.isInfinite()) l = new Line(x,0,x,height);
    
    /*
    // SPIDERWEB?
    float x; float y;
    Float m; float c;
    if (random(1) < 0.5){
      float angle = (((float)ceil(random(6)))/ 6) * PI - HALF_PI;
      x = width/2 + (250+random(25))*cos(angle) * (floor(random(2))*2-1);
      y = height/2 + (250+random(25))*sin(angle) * (floor(random(2))*2-1);
      m = tan(angle);
      float tangent = (-1)/m;
      c = y - tangent*x;
    }
    else {
      x = width/2;// + random(100)-50;
      y = height/2;// + random(100)-50;
      float angle = random(PI) - HALF_PI;
      m = tan(angle);
      c = y - m*x;
      if (angle == HALF_PI || angle == -HALF_PI) m = Float.POSITIVE_INFINITY;
    }
    l = new Line(x, y, 0, c);
    if (m.isInfinite()) l = new Line(x,0,x,height);*/
    
    
    v.connectAll(l, sizePercentage, elasticity);
    //v.connectMost(l, sizePercentage, elasticity, 15);
    
    //l.show(#00ff55,2.5);
  }
  
  print(frameCount + "    " + frameRate + "\n");
  
  //recordUpdate();
}
