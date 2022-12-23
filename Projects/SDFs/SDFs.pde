PShader shader;
float radius = 0.2;
float dropoffAmnt = 20.0;
float stepAmnt = 80.0;
PVector mousePos = new PVector(mouseX, mouseY);

void setup(){
  size(1000,1000,P2D);
  background(0);
  shader = loadShader("SDF.glsl");
  shader.set("resolution",width,height);
}

void draw(){
  
  mousePos = new PVector(mouseX,height-mouseY);
  if (keyPressed){
    if (keyCode == UP) radius += 0.01;
    if (keyCode == DOWN) radius -= 0.01;
    if (keyCode == RIGHT) dropoffAmnt += 0.1;
    if (keyCode == LEFT) dropoffAmnt -= 0.1;
    if (key == '1') stepAmnt += 0.1;
    if (key == '0') stepAmnt -= 0.1;
  }
  
  shader.set("radius",radius);
  shader.set("dropoffAmnt",dropoffAmnt);
  shader.set("stepAmnt",stepAmnt);
  shader.set("circlePos",mousePos.x,mousePos.y);
  //shader.set("circlePos2",width/2+200*cos(frameCount*0.02), height/2+200*sin(frameCount*0.02));
  shader(shader);
  rect(0,0,width,height);
  diagnostics();
}
