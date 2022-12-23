Differential main;
float len = 150;
int num = 20;

float maxForce = 10;
float damping = 0.7;

float rejectionRadius = 75;
float rejectionMultiplier = 1.5;
float splitLength = 20;
float attractionMultiplier = 0.02;
float attractionLimit = 25;

boolean activated = true;
int frameLimit = 1800;

void setup(){
  size(1000,1000);
  background(0);
  
  main = new Differential(width/2f, height/2f, "MESH", len, num);
  //main.debugShow();
  //noLoop();
}

void draw(){
  if(activated){
    main.update(rejectionRadius, rejectionMultiplier, splitLength, attractionMultiplier, attractionLimit);
  }
  
  //main.show();
  background(0); main.debugShow();
  
  //print(frameCount + "\n");
  //saveFrame("Brain/frame_####.png");
  //if(frameCount >= frameLimit) noLoop();
}

void mouseClicked(){
  //save("Coral.png");
  activated = false;
}
