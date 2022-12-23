PImage resizeImage(PImage src, int w, int h){
  PImage output = createImage(w,h,ARGB);
  src.loadPixels();
  output.loadPixels();
  for (int y = 0; y < h; y++){
    for (int x = 0; x < w; x++){
      int targetX = floor((float)x / (float)w * src.width);
      int targetY = floor((float)y / (float)h * src.height);
      output.pixels[y*w+x] = src.pixels[targetY*src.height+targetX];
    }
  }
  output.updatePixels();
  return output;
}
