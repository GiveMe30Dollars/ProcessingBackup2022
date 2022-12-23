class Quark extends Walker{
  color stillCol; color speedCol;
  Quark(float x_, float y_, color stillCol_, color speedCol_){
    super(x_,y_);
    stillCol = stillCol_;
    speedCol = speedCol_;
  }
  
  void show(int num, float scatterMultiplier){
    float scatter = scatterMultiplier*velocity.mag();
    color col = lerpColor(stillCol, speedCol, reciprocalLimit(scatter,1,0.07));
    for (int i = 0; i < floor(num*scatter); i++){
      float randomX = randomGaussian()*scatter;
      float randomY = randomGaussian()*scatter;
      noStroke(); fill(col);
      circle(x+randomX, y+randomY, 2);
    }
  }
}

//float scatterMultiplier = 10;
