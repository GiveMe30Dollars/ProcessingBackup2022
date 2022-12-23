float damping = 0.5;
float maxSpeed = 5;
float speedMultiplier = 3;

float stripMargin = 35;
float canvasMargin = 20;

float scale = 0.001;
int seed = 1;
int lifetime = 30;

FidenzaSystem sys;

void setup(){
  size(1000,1000,P2D);
  background(0);
  sys = new FidenzaSystem();
  //recordStart(1800, "Exports/FidenzaMacroMicro.mp4");
}

void draw(){
  background(0);
  if (frameCount % 3 == 0 && frameCount < 300) sys.addStrip("MACRO");
  if (frameCount % 1 == 0 && frameCount == 300){
    stripMargin = 10;
    lifetime = 30;
  }
  if (frameCount % 1 == 0 && frameCount > 300) sys.addStrip("MICRO");
  sys.update();
  sys.show();
  
  //diagnostics();
  //recordUpdate();
}
