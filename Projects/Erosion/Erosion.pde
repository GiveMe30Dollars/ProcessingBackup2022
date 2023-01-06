

float [][] noiseMap;
float [][] original;
float zoom = 0.0035;

int octaves = 2;
float lacunarity = 1.5;
float persistence = 0.4;

float inertia = 0.2;
float capacity = 10;
float erosion = 0.10;
float deposition = 0.10;
float evaporation = 0.02;
float radius = 3.5;
float gravity = 10;

float maxSteps = 150;
float minSlope = 0.00001;

ArrayList<Raindrop> particles;


void setup(){
  
  size(1000,1000,P3D);
  
  noiseMap = layeredNoise(500, 500, zoom, octaves, lacunarity, persistence);
  noiseMap = powerNoiseMap(noiseMap,1.2);
  
  original = noiseMap.clone();
  for(int i = 0; i < noiseMap.length; i++){
    original[i] = noiseMap[i].clone();
  }
  
  particles = new ArrayList<Raindrop>();
}

void draw(){
  
  background(0);
  //if (frameCount <= 1000){
  if (true){
    for (int i = 0; i < 150; i++){
      Raindrop p = new Raindrop(random(noiseMap[0].length-4)+2, random(noiseMap.length-4)+2);
      particles.add(p);
    }
  }
  
  for (int i = 0; i < 5; i++){
    for (Raindrop p : particles){
      p.update(noiseMap);
    }
  }
  // view2D(noiseMap);
  view3D(noiseMap);
  navigate3D();
  
  
  
  // GARBAGE COLLECTOR
  print("\nACTIVE PARTICLES: " + particles.size());
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
