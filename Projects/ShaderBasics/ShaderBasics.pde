PShader lit;
PShader metaballs;
float reach = 0.025;
PVector lightPos = new PVector(0,0);

Metaballs sys;

void setup(){
  size(1000,1000,P2D);
  background(0);
  lit = loadShader("light.glsl");
  metaballs = loadShader("metaballs.glsl");
  recordStart(1200,"Exports/Metaballs.mp4",60);
  
  sys = new Metaballs(30,metaballs);
}

void draw(){
  /*
  lit.set("resolution",width,height);
  lit.set("lightPosition",lightPos.x,lightPos.y);
  lit.set("reach",reach);
  shader(lit);
  rect(0,0,width,height);*/
  
  
  //theNormal();
  lightPos = new PVector(mouseX,height-mouseY);
  //lightPos = new PVector(width/2+200*cos(millis()*0.005), height/2+200*sin(millis()*0.005));
  diagnostics();
  recordUpdate();
  
  
  sys.update();
  sys.show();
  
  
}

void keyReleased(){
  if (keyCode == UP) reach += 0.01;
  if (keyCode == DOWN) reach -= 0.01;
}
