ArrayList<Collider> obstacles;
ArrayList<Photon> photons;
float speed = 15;

void setup(){
  size(1000,1000);
  background(0);
  // INSTANTIATE COLLIDERS; SEE ObstacleGeneration_Method
  obstacles = generateVoronoiColliders();
  photons = new ArrayList<Photon>();
  for (int i = 0; i < 1000; i++){
    photons.add(new Photon(width/2, height/2, PVector.random2D().mult(speed)));
  }
  frameCount = 0;
  //showColliders();
}

float decayFactor = speed*0.05;

void draw(){
  //background(0);
  /*
  PImage bg = get();
  background(0);
  tint(255,220,200,100);
  image(bg,0,0);*/
  
  color lightCol = color(255,255,255, 255-frameCount*decayFactor);
  for (Photon p : photons){
    p.update(obstacles);
    p.show(lightCol, lightCol, 0, 1);
  }
  
  
}

void keyPressed(){
  if (key==ENTER) setup();
}

void showColliders(){
  color glassCol = color(200,200,200,128);
  color glassEdgeCol = color(200,200,200,200);
  for (Collider c : obstacles){
    if (obstacles.indexOf(c) == 0) continue;
    c.show(glassCol, glassEdgeCol, 2.5);
  }
}
