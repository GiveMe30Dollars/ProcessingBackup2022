void sandLine(float x1, float y1, float x2, float y2, color c, int pointPerLine, int lineNumber, float offset, float posSD, float colorSD){
  PVector u = new PVector(x1,y1);
  PVector v = new PVector(x2,y2);
  color col = c;
  stroke(col);
  fill(col);
  
  for(int n = 0; n < lineNumber; n++){
    stroke(col);
    fill(col);
    for (float i = 0; i < pointPerLine; i++){
      int x = floor(lerp(u.x, v.x, i/pointPerLine));
      int y = floor(lerp(u.y, v.y, i/pointPerLine));
      x = max(0, min(width, x));
      y = max(0, min(height, y));
      circle(x,y,2);
    }
    u = new PVector(x1,y1);
    v = new PVector(x2,y2);
    PVector uOffset = PVector.random2D().mult(offset+abs(randomGaussian()*posSD));
    PVector vOffset = PVector.random2D().mult(offset+abs(randomGaussian()*posSD));
    u.add(uOffset);
    v.add(vOffset);
    float h = hue(c) + randomGaussian()*colorSD;
    float s = saturation(c) + randomGaussian()*colorSD;
    float b = brightness(c) + randomGaussian()*colorSD;
    colorMode(HSB);
    col = color(h, s, b, alpha(c));
    colorMode(RGB);
  }
}

void sandLine(float x1, float y1, float x2, float y2, color c){
  sandLine(x1,y1,x2,y2,c, 150, 10, 1.5, 2, 0.5);
}
