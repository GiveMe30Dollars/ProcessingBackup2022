class Metaballs{
  float[] posX;
  float[] posY;
  float[] velX;
  float[] velY;
  PShader shader;
  Metaballs(int i_, PShader shader_){
    shader = shader_;
    posX = new float[i_];
    posY = new float[i_];
    velX = new float[i_];
    velY = new float[i_];
    for (int i = 0; i < i_; i++){
      posX[i] = random(width);
      posY[i] = random(height);
      velX[i] = random(4)-2;
      velY[i] = random(4)-2;
    }
    shader.set("n",i_);
  }
  
  void update(){
    for (int i = 0; i < posX.length; i++){
      posX[i] += velX[i];
      posY[i] += velY[i];
      if (posX[i] < 0) velX[i] = abs(velX[i]);
      if (posX[i] > width) velX[i] = -abs(velX[i]);
      if (posY[i] < 0) velY[i] = abs(velY[i]);
      if (posY[i] > height) velY[i] = -abs(velY[i]);
      //print(i + "    " + posX[i] + "    " + posY[i] + "\n");
    }
  }
  
  void show(){
    shader.set("posX", posX);
    shader.set("posY", posY);
    shader.set("n", posX.length);
    shader.set("resolution",width,height);
    shader.set("reach",reach);
    shader(shader);
    rect(0,0,width,height);
    resetShader();
  }
}
