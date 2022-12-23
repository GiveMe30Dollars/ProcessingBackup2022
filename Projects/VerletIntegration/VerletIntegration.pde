float gravity = 1.5;
float bounce = 0.7;
float friction = 0.999;
float groundFriction = 0.97;

VerletSystem v;

int stickUpdates = 1;

void setup(){
  size(1000,1000);
  background(0);
  
  v = new VerletSystem();
  
  //Ball b0 = new Ball(100,100,true);
  Ball b0 = new Ball(100,100,95,103);
  //Ball b1 = new Ball(200,100,90+random(90),150+random(50));
  Ball b1 = new Ball(200,100,true);
  Ball b2 = new Ball(100,200);
  Ball b3 = new Ball(200,200);
  
  v.addPoint(b0);
  v.addPoint(b1);
  v.addPoint(b2);
  v.addPoint(b3);
  v.addStick(0,1);
  v.addStick(0,2);
  v.addStick(2,3);
  v.addStick(1,3);
  
  v.addStick(1,2,false);
  v.addStick(0,3,false);
  
  //stickUpdates = ceil(random(5));
  
  
  //if (frameCount == 0) recordStart(3600,"Exports/JellyBouncing.mp4");
}

void draw(){
  
  background(0);
  v.update(stickUpdates);
  v.show();
  textSize(20);
  //text("Stick Updates: " + stickUpdates,15,25);
  
  if (frameCount % 200 == 0) setup();
  //recordUpdate();
  //print(frameCount + "\n");
}

void mouseClicked(){
  //setup();
}
