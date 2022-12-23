void setup(){
  size(1000,1000);
  
  /*
  for (int j = 0;  j < 2; j++){
    loadPixels();
    for (int y = 0; y < height; y++){
      for (int x = 0; x < width; x++){
        int i = y*width+x;
        PVector displacement = PVector.fromAngle(brightness(pixels[i])/256f*TWO_PI).mult(brightness(pixels[i]));
        pixels[i] = color(noise((x+displacement.x)*0.01,(y+displacement.y)*0.01)*256);
      }
    }
    updatePixels();
  }*/
  
  loadPixels();
  for (int y = 0; y < height; y++){
    for (int x = 0; x < width; x++){
      int i = y*width+x;
      PVector displacement = new PVector(noise(x*0.01,y*0.01),noise(y*0.01,x*0.01)).mult(1000);
      pixels[i] = color(noise((x+displacement.x)*0.01,(y+displacement.y)*0.01)*256);
    }
  }
  updatePixels();
}

void draw(){
  //filter(THRESHOLD);
  
    
}
