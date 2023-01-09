ArrayList<Collider> obstacles;
ArrayList<Photon> photons;
float speed = 15;
float gaussianStrength = 1.0;

float decayAmount;
float decayFactor = 0.990;

void setup(){
  size(1000,1000);
  background(0);
  init();
}

void init(){
  // INSTANTIATE COLLIDERS; SEE ObstacleGeneration_Method
  background(0);
  
  //obstacles = generateVoronoiColliders();
  obstacles = generateCircleCollider();
  
  photons = new ArrayList<Photon>();
  for (int i = 0; i < 2000; i++){
    //photons.add(new Photon(width/2, height/2, PVector.random2D().mult(speed+randomGaussian()*gaussianStrength)));
    photons.add(new Photon(width/2+randomGaussian()*100, 0.1, new PVector(randomGaussian()*0.1,1).mult(speed+randomGaussian()*gaussianStrength)));
    //photons.add(new Photon(width/2+randomGaussian()*100, height-0.1, new PVector(randomGaussian()*0.05,-1).mult(speed+randomGaussian()*gaussianStrength)));
  }
  decayAmount = 255;
  //showColliders();
}

void draw(){
  //background(0);
  /*
  PImage bg = get();
  background(0);
  tint(255,220,200,100);
  image(bg,0,0);*/
  
  color lightCol = color(255,255,255, decayAmount);
  for (Photon p : photons){
    p.update(obstacles);
    p.show(lightCol, lightCol, 0, 1);
  }
  decayAmount *= decayFactor;
  
  print("\nDIAGNOSTICS: "+frameCount+"    "+frameRate);
  
  //saveFrame("C:/Users/willi/Pictures/Photons/Pillars/####.png");
  //if (frameCount%100 >= 99) init();
  //if (frameCount >= 1600) noLoop();
}

void keyPressed(){
  if (key==ENTER) init();
}

void showColliders(){
  color glassCol = color(200,200,200,16);
  color glassEdgeCol = color(64);
  for (Collider c : obstacles){
    if (obstacles.indexOf(c) == 0) continue;
    c.show(glassCol, glassEdgeCol, 1.5);
  }
}
