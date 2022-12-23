ArrayList<Walker> walkers;
DelaunaySystem sys;

void setup(){
  size(1000,1000);
  background(0);
  walkers = new ArrayList<Walker>();
  for (int i = 0; i < 1500; i++){
    walkers.add(new Walker(random(width),random(height))); 
  }
  
  //recordStart(3600,"Exports/DUMP.mp4");
}

float circleSize = 250;
float scaleDiff = 10;
float aberrateVal = 10;

void draw(){
  //background(0);
  /*
  PImage canvas = get();
  tint(240,210,100,200);
  image(canvas,0,0);*/
  
  PImage canvas = get();
  tint(200,200,200,75);
  //if (frameCount % 20 == 0) aberrateVal += randomGaussian();
  canvas = aberrate(canvas,aberrateVal);
  //canvas.filter(BLUR);
  image(canvas,0,0);
  /*
  PImage canvas = get();
  tint(200,200,200,200);
  canvas = aberrate(canvas,noise(frameCount*0.1)*noise(frameCount*0.2)*20);
  image(canvas,0,0);*/
  /*
  PImage canvas = get();
  tint(240,210,100,230);
  canvas.resize( floor(width+scaleDiff*2) , 0);
  image(canvas,-scaleDiff,-scaleDiff);*/
  /*
  PImage canvas = get();
  tint(255,255,255,230);
  background(0);
  canvas = aberrate(canvas,10);
  canvas.resize( floor(width+scaleDiff*2) , 0);
  image(canvas,-scaleDiff,-scaleDiff);*/
  
  
  for (Walker w : walkers){
    w.show(#ffffff,255);
    w.update();
  }
  
  diagnostics();
  //recordUpdate();
}
