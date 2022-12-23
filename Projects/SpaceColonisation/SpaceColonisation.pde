
Tree tree;

// NORMAL DISTRIBUTION OF AUXIN
float sd = 150;
float lim = 2.75;

// BASE SIMULATION
float killDist = 3;
float growthDist = 2.5;
float maxRadius = 200;

// VEIN THICKENING
float minThickness = 1.5;
float thicknessIncrement = 0.05;
float maxThickness = 3;

// GROWTH
float roughness = 0.3;

//ArrayList<Tree> trees;

void setup(){
  size(1000,1000);
  background(0);
  tree = new Tree();
  tree.addNode(width/2,height/2);
  /*
  int num = 40;
  float radius = 300;
  for (float angle = 0; angle < TWO_PI; angle += TWO_PI/num){
    //float x = radius*cos(angle) + width/2;
    //float y = radius*sin(angle) + height/2;
    float x = max(min(randomGaussian(),lim),-lim) * sd + width/2;
    float y = max(min(randomGaussian(),lim),-lim) * sd + height/2;
    tree.addNode(x,y);
  }*/
  
  for (int i = 0; i < 3000; i++){
    float x = max(min(randomGaussian(),lim),-lim) * sd + width/2;
    float y = max(min(randomGaussian(),lim),-lim) * sd + height/2;
    tree.addAuxin(x,y);
  }
  
  //trees = new ArrayList<Tree>();
  //trees.add(tree);
  //recordStart(300,"Exports/DUMP.mp4",30);
}

void draw(){
  //background(0);
  
  PImage canvas = get();
  tint(130,230,100,100);
  image(canvas,0,0);
  /*
  PImage canvas = get();
  canvas = aberrate(canvas,20+sin(frameCount*0.01)*2);
  tint(200,200,200,75);
  canvas.filter(BLUR);
  image(canvas,0,0);*/
  
  tree.update("CLOSED");
  tree.show();
  
  /*
  if (frameCount % 10 == 1 && frameCount < 450){
    trees.add(new Tree(width/2, height/2));
    for (int i = 0; i < 2000; i++){
      float x = max(min(randomGaussian(),lim),-lim) * sd + width/2;
      float y = max(min(randomGaussian(),lim),-lim) * sd + height/2;
      trees.get(trees.size()-1).addAuxin(x,y);
    }
  }
  for (int i = trees.size()-1; i >= 0; i--){
    Tree t = trees.get(i);
    t.update("OPEN");
    t.show();
    if (t.auxins.size() <= 0) trees.remove(trees.indexOf(t));
  }*/
  
  
  
  diagnostics();
  //recordUpdate();
}

void keyPressed(){
  if(key == ENTER) setup();
}
