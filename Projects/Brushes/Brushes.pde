/*

PerlinBrush pb;

void setup(){
  size(1000,1000);
  background(240);
  pb = new PerlinBrush();
  recordStart(-1,"Exports/Basics.mp4");
}

void draw(){
  recordUpdate();
}

void mousePressed(){
  pb.show(mouseX, mouseY, color(0,30,50,16));
}

void mouseDragged(){
  pb.show(mouseX, mouseY, color(0,30,50,16));
}*/


// TERRACES COPY

float [][] noiseMap;
float zoom = 0.005;

int octaves = 3;
float lacunarity = 1.5;
float persistence = 0.3;

float maxSpeed = 10;
float forceMultiplier = 200;
float damping = 0.8;

ArrayList<FlowParticle> particles;
/*
void setup(){
  
  size(1000,1000);
  background(255);
  //background(0);
  
  //noiseSeed(0);
  noiseMap = layeredNoise(width, height, zoom, octaves, lacunarity, persistence);
  particles = new ArrayList<FlowParticle>();
  for (int i = 0; i < 500; i++){
    FlowParticle p = new FlowParticle(random(width-2)+1, random(height-2)+1);
    particles.add(p);
  }
  //recordStart(500,"Exports/Rivershed.mp4");
}

void draw(){
  if (frameCount >= 500) noLoop();
  for (FlowParticle p : particles){
    //damping = lerp(0,1,(float)p.x/width);    // DYNAMIC DAMPING OVER X AXIS
    int x_ = round(p.x);
    int y_ = round(p.y);
    p.update(noiseMap);
    if (p.enabled){
      //color c = color(noiseMap[x_][y_]*196+60);    // CANVAS WHITE-TO-BLACK VARIETY
      //color c = color(noiseMap[x_][y_]*(-196)+100);  // CANVAS BLACK-ON-WHITE VARIETY
      colorMode(HSB); color c = color(140, 255, noiseMap[x_][y_]*196+60); colorMode(RGB); // CANVAS BLUE-ON-WHITE VARIETY
      //color c = color(255,0,0);    // PURE RED
      
      p.show(c, 16);    // SHOW BASED ON CURRENT POSITION
    }
  }
  
  //diagnostics();
  //recordUpdate();
}*/

Watercolour wc;

void setup(){
  size(1000,1000);
  background(255);
  wc = new Watercolour(200,5);
  wc.generateBase(4);
  recordStart(500,"Exports/RedBlob.mp4",20);
}

void draw(){
  background(255);
  wc.show(color(255,0,0,4),75,5);
  wc.base.show(color(255,0,0,32));
  //diagnostics();
  recordUpdate();
}
