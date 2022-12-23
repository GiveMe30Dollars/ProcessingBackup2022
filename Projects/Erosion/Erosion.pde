
import com.hamoid.*;

float [][] noiseMap;
float [][] original;
float zoom = 0.0035;

int octaves = 2;
float lacunarity = 1.5;
float persistence = 0.4;

float inertia = 0.2;
float capacity = 4;
float erosion = 0.1;
float deposition = 0.1;
float evaporation = 0.02;
float radius = 3.5;
float gravity = 10;

float maxSteps = 150;
float minSlope = 0.00001;

ArrayList<Raindrop> particles;

void setup(){
  
  size(1000,1000,P3D);
  
  rotateX(PI);
  
  noiseMap = layeredNoise(500, 500, zoom, octaves, lacunarity, persistence);
  noiseMap = powerNoiseMap(noiseMap,1.2);
  
  original = noiseMap.clone();
  for(int i = 0; i < noiseMap.length; i++){
    original[i] = noiseMap[i].clone();
  }
  
  particles = new ArrayList<Raindrop>();
  /*
  for (int i = 0; i < 20000; i++){
    Raindrop p = new Raindrop(random(noiseMap[0].length-4)+2, random(noiseMap.length-4)+2);
    particles.add(p);
  }*/
  
  //recordStart(1250,"Exports/Raining.mp4",60);
}

float xRotation = PI/4;
float zRotation = PI/2;
float threshold = 0.0015;
float blendAmt = 0.002;

void draw(){
  
  background(0);
  if (frameCount <= 1000){
  //if (true){
    for (int i = 0; i < 100; i++){
      Raindrop p = new Raindrop(random(noiseMap[0].length-4)+2, random(noiseMap.length-4)+2);
      particles.add(p);
    }
  }
  /*
  // 2D VIEW
  loadPixels();
  for (int y = 0; y < height; y++){
    for (int x = 0; x < width; x++){
      pixels[y*width+x] = color(noiseMap[x][y]*256);
    }
  }
  updatePixels();*/
  
  for (Raindrop p : particles){
    p.update(noiseMap);
    //p.show();
  }
  
  
  // 3D VIEW
  translate(width/2, height/2,-650);
  rotateX(xRotation);
  rotateZ(zRotation);
  translate(-width/2, -height/2);
  colorMode(RGB);
  lights();
  directionalLight(255, 255, 255, 1, 1, 0);
  noStroke();
  
  color soil = #65504a;
  color grass = #ffffff;
  fill(128);
  
  for (int y = 0; y < noiseMap.length-1; y++){
    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < noiseMap[0].length; x++){
      // HEIGHT COLOR
      //fill(lerp(0,255,noiseMap[x][y]*noiseMap[x][y]));
      /*
      // EROSION DIFFERENCE COLOR
      colorMode(HSB);
      float diff = original[x][y] - noiseMap[x][y];
      color c = color(150, diff*1000, noiseMap[x][y]*255);
      fill(c);*/
      
      // GRADIENT AND HEIGHT COLOR
      if(x >= noiseMap[0].length-1 || y >= noiseMap.length-1){
        vertex(x*2, y*2, noiseMap[x][y]*400-100);
        vertex(x*2, (y+1)*2, noiseMap[x][y+1]*400-100);
        continue;
      }
      PVector gradient = calculateGradient(noiseMap,(float)x+0.5, (float)y+0.5);
      float gradientMag = gradient.mag();
      color c;
      if (gradientMag < threshold - blendAmt) c = grass;
      else if (gradientMag > threshold + blendAmt) c = soil;
      else {
        float lerpVal = inverseLerp(threshold-blendAmt, threshold+blendAmt, gradientMag);
        c = lerpColor(grass, soil, lerpVal);
      }
      fill(lerpColor(#000011, c, noiseMap[x][y]));
      
      vertex(x*2, y*2, noiseMap[x][y]*400-100);
      vertex(x*2, (y+1)*2, noiseMap[x][y+1]*400-100);
    }
    endShape();
  }
  
  // GARBAGE COLLECTOR
  print("ACTIVE PARTICLES: " + particles.size() + "\n");
  for (int i = particles.size()-1; i >= 0; i--){
    Raindrop p = particles.get(i);
    if (!p.enabled) particles.remove(i);
  }
  
  if (keyPressed){
    if (keyCode == UP && xRotation > 0) xRotation -= 0.05;
    if (keyCode == DOWN && xRotation < PI/2) xRotation += 0.05;
    if (keyCode == LEFT) zRotation -= 0.05;
    if (keyCode == RIGHT) zRotation += 0.05;
  }
  
  //recordUpdate();
}

void keyPressed(){
}

/*
void mouseClicked(){
  save("Perlin.png");
}*/
