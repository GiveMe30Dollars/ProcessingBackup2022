CASystem sys;
NCASystem nsys;

color col = color(random(256),random(256),random(256));

void setup(){
  size(1000,1000);
  background(0);
  
  //sys = new CASystem(500,500,0.5);
  //sys.addRules(5, 33, 57, 34, 45, false);
  //sys.addRules(5, 0.275, 0.475, 0.28333, 0.375, true);
  
  nsys = new NCASystem(249,249,0.1);
  
  frameRate(999);
  //recordStart(300,"Exports/NCA/AbsCosine.mp4",20);
  colorMode(HSB);
  col = color(random(256),128+random(128),128+random(128));
  colorMode(RGB);
}

void draw(){
  background(0);
  /*
  PImage canvas = get();
  tint(210,170,100,200);
  image(canvas,0,0);*/
  
  noTint();
  //sys.update();
  //sys.show(#ffffee);
  nsys.update();
  nsys.show(col);
  
  //recordUpdate();
}

void keyPressed(){
  if (key == ENTER){
    colorMode(HSB);
    col = color(random(256),128+random(128),128+random(128));
    colorMode(RGB);
    setup();
  }
  if (key == ' '){
    print (nsys.weights[0][0]+"  "+nsys.weights[0][1]+"  "+nsys.weights[0][2]+"\n");
    print (nsys.weights[1][0]+"  "+nsys.weights[1][1]+"  "+nsys.weights[1][2]+"\n");
    print (nsys.weights[2][0]+"  "+nsys.weights[2][1]+"  "+nsys.weights[2][2]+"\n\n");
  }
  
}
