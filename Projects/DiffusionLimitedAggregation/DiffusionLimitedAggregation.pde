float radius = 4;
int capacity = 30;
int updateNumber = 20;

DLASystem dla;

void setup(){
  background(0);
  size(1000,1000);
  dla = new DLASystem();
  frameRate(999);
  
  recordStart(3600,"Exports/RandomSlipperyColor.mp4");
}

void draw(){
  background(0);
  /*
  PImage canvas = get();
  background(0);
  tint(128,196,255,200);
  image(canvas,0,0);*/
  
  if (frameCount % 1 == 0 && frameCount <= 2000){
    dla.addWanderer();
    dla.addWanderer();
    dla.addWanderer();
    dla.addWanderer();
    dla.addWanderer();
  }
  for (int i = 0; i < updateNumber; i++){
    dla.update(0.2);
  }
  dla.show();
  
  recordUpdate();
  //diagnostics();
}
