DelaunaySystem sys;
float margin = 200;

ArrayList<FlowParticle> particles;

void setup(){
  size(1000,1000,P2D);
  background(0);
  sys = new DelaunaySystem();
  particles = new ArrayList<FlowParticle>();
  noiseMap = layeredNoise(width, height, zoom, octaves, lacunarity, persistence);/*
  for (int i = 0; i < 100; i++){
    //FlowParticle p = new FlowParticle(random(width-2)+1, random(height-2)+1);
    FlowParticle p = new FlowParticle(random(width-margin*2)+margin, random(height-margin*2)+margin);
    particles.add(p);
  }*/
  //recordStart(3600, "Exports/Stringy.mp4");
}

void draw(){
  //background(25);
  
  PImage canvas = get();
  background(0);
  tint(64,255,128,128);
  //tint(32,128,32,200);
  image(canvas,0,0);
  
  //if (frameCount % 10 == 0) sys.add(random(width-margin*2)+margin, random(height-margin*2)+margin);
  
  if (frameCount % 10 == 0) particles.add(new FlowParticle(random(width-margin*2)+margin, random(height-margin*2)+margin));
  for (FlowParticle p : particles){
    //damping = lerp(0,1,(float)p.x/width);    // DYNAMIC DAMPING OVER X AXIS
    p.update(noiseMap);
  }
  sys = new DelaunaySystem(particles);
  //sys.show();
  
  for (DTriangle triangle : sys.finiteTriangles()){
    Polygon p = new Polygon();
    p.add(triangle.a.x, triangle.a.y);
    p.add(triangle.b.x, triangle.b.y);
    p.add(triangle.c.x, triangle.c.y);
    p = scale(p,0.9);
    p = chaikinCurve(p,0.15);
    p = chaikinCurve(p,0.15);
    p = chaikinCurve(p,0.15);
    p.show(#ffffff, #ffffff, 0);
  }
  
  diagnostics();
  //recordUpdate();
}
/*
void mouseClicked(){
  //sys.add(mouseX, mouseY);
  particles.add(new FlowParticle(mouseX,mouseY));
}*/
