class PerlinBrush {
  int num = 20;
  float len = 50;
  float sdOffset = 10;
  float sdStroke = 1;
  float scale = 0.02;
  PerlinBrush(){}
  PerlinBrush(int num_, float len_, float sdO_, float sdS_, float scale_){
    num = num_;
    len = len_;
    sdOffset = sdO_;
    sdStroke = sdS_;
    scale = scale_;
  }
  PerlinBrush(int num_, float len_, float scale_){
    num = num_;
    len = len_;
    scale = scale_;
  }
  
  void show(float x, float y, color col){
    for (int i = 0; i < num; i++){
      stroke(col);
      float x1 = x + randomGaussian()*sdOffset;    // GET INITIAL POSITION BASED ON GAUSSIAN DISTRIBUTION
      float y1 = y + randomGaussian()*sdOffset;
      float x2 = x1 + 2*len*(noise(x1*scale,y1*scale)-0.5);    // GET SECOND POSITION BASED ON FLOW FIELD
      float y2 = y1 + 2*len*(noise(y1*scale,x1*scale)-0.5);
      strokeWeight(map(brightness(col),0,255,2,0.1) + abs(randomGaussian()*sdStroke));
      line(x1,y1,x2,y2);
    }
  }
}
