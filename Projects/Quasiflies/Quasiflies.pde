ArrayList<Firefloid> firefloids = new ArrayList<Firefloid>();
Quadtree<Firefloid> qTree;

int frameLimit = 30000;

float maxSpeed = 4;
float mass = 2;
float viewRange = 75;
float viewAngle = 220;

float multiplier_A = 0.3;
float multiplier_C = 0.11;
float multiplier_S = 4.8;
float multiplier_O = 0.0018; 
float damping = 0.7;
float size = 7;

void setup(){
  size(1000,1000);
  background(25);
  
  generateBoids();
  //multiplier_O = 0;
}

void generateBoids(){
  qTree = new Quadtree<Firefloid>(0,0,width, height,50);
  firefloids = new ArrayList<Firefloid>();
  for (int i = 0; i < 100; i++){
    Firefloid b = new Firefloid(random(width), random(height));
    firefloids.add(b);
    qTree.insert(b);
  }
}

void draw(){
  PImage screen = get();
  background(25);
  tint(200,175);
  image(screen, 0, 0);
  
  qTree.reset();
  qTree.insert(firefloids);
  
  for (Firefloid b : firefloids){
    b.update(qTree, "REDUNDANCY BECAUSE JAVA's AN IDIOT");
    b.show(color(128), color(25), color(255,200,0), size);
  }
  
  print(frameRate+"\n");
  
  //if(keyPressed) updateParameters();
  //displayParameters();
}
