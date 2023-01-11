

float [][] noiseMap;
float [][] streamMap;
float [][] original;

float inertia = 0.2;
float capacity = 10;
float erosion = 0.10;
float deposition = 0.10;
float evaporation = 0.02;
float radius = 3.5;
float gravity = 10;

float streamInertiaFactor = 0.5;
float streamEvaporationFactor = 0.2;
float streamWrite = 0.1;
float streamDecay = 0.01;
float streamRadius = 2.0;

float maxSteps = 250;
float minSlope = 0.00001;

ArrayList<Raindrop> particles;


void setup(){
  
  size(1000,1000,P3D);
  
  noiseMap = layeredNoise(500, 500, 0.0035, 2, 1.5, 0.4);
  noiseMap = powerNoiseMap(noiseMap,1.2);
  
  original = noiseMap.clone();
  for(int i = 0; i < noiseMap.length; i++){
    original[i] = noiseMap[i].clone();
  }
  
  streamMap = new float[500][500];
  
  particles = new ArrayList<Raindrop>();
}

void draw(){
  
  background(0);
  //if (frameCount <= 1000){
  if (true){
    for (int i = 0; i < 60; i++){
      Raindrop p = new Raindrop(random(noiseMap[0].length-4)+2, random(noiseMap.length-4)+2);
      particles.add(p);
    }
  }
  
  for (int i = 0; i < 2; i++){
    for (Raindrop p : particles){
      p.update(noiseMap, streamMap);
    }
    multAll(streamMap, 1-streamDecay);
  }
  // view2D();
  view3D();
  navigate3D();
  
  
  
  // GARBAGE COLLECTOR
  print("\nACTIVE PARTICLES: " + particles.size() + "    " + frameRate);
  for (int i = particles.size()-1; i >= 0; i--){
    Raindrop p = particles.get(i);
    if (!p.enabled) particles.remove(i);
  }
  
  recordUpdate();
}


/*
void mouseClicked(){
  save("Perlin.png");
}*/
