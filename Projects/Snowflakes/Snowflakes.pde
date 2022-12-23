float radius = 2.0;
int capacity = 30;

Snowflake s;

void setup(){
  size(1000,1000);
  s = new Snowflake();
  frameRate(999);
  recordStart(3600,"Gathering.mp4",60);
}

float slowAngle = 0;

void draw(){
  PImage canvas = get();
  background(0);
  tint(64,196,255,235);
  image(canvas,0,0);
  
  if (frameCount % 1 == 0 && frameCount <= 3300) s.addWanderer();
  s.update();
  s.update();
  s.update();
  s.update();
  translate(width/2, height/2);
  rotate(slowAngle);
  s.show();
  
  slowAngle += 0.0015;
  recordUpdate();
}
