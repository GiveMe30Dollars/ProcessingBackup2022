PImage aberrate(PImage src, float d){
  PImage output = createImage(src.width,src.height,RGB);
  src.loadPixels();
  output.loadPixels();
  for (int y = 0; y < src.height; y++){
    for (int x = 0; x < src.width; x++){
      float valRed = getValue(src, x-floor(d*0.8660), y-floor(d/2));
      float valGreen = getValue(src, x+floor(d*0.8660), y-floor(d/2));
      float valBlue = getValue(src, x, y+floor(d));
      output.pixels[y*src.width+x] = color(valRed, valGreen, valBlue);
    }
  }
  output.updatePixels();
  return output;
}

float getValue(PImage src, int x, int y){
  return getValue(src,x,y,brightness(src.pixels[0]));
}
float getValue(PImage src, int x, int y, float defaultVal){
  if (x < 0 || x >= src.width || y < 0 || y >= src.height) return defaultVal;
  else return brightness(src.pixels[y*src.width+x]);
}
