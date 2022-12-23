PImage sobelOperator(PImage img){
  img.loadPixels();
  PImage grayscale = img.get();
  grayscale.filter(GRAY);
  
  float[][] horizontalMask = new float[][]{{-1,0,1}, {-2,0,2}, {-1,0,1}};
  float[][] verticalMask = new float[][]{{-1,-2,-1}, {0,0,0}, {1,2,1}};
  
  PImage outputX = applyKernel(grayscale, horizontalMask);  // generates image. mids at 128, negative value at 0, positive value at 255
  PImage outputY = applyKernel(grayscale, verticalMask);  // see above
  PImage output = new PImage(img.width, img.height);
  outputX.loadPixels();
  outputY.loadPixels();
  output.loadPixels();
  
  for (int i = 0; i < output.pixels.length; i++){
    float valueX = inverseLerp(0,255,brightness(outputX.pixels[i])) * 2 - 1;  // obtains x value from -1 to 1 in image
    float valueY = inverseLerp(0,255,brightness(outputY.pixels[i])) * 2 - 1;  // obtains y value from -1 to 1 in image
    float dst = sqrt(valueX*valueX + valueY*valueY); // calculates magnitude from -sqrt2 to sqrt2
    output.pixels[i] = color(dst/sqrt(2)*(float)255);
  }
  
  output.updatePixels();
  return output;
}

float inverseLerp(float a, float b, float v){
  return (v-a)/(b-a);
}




PImage sobelOperatorColor(PImage img){
  img.loadPixels();
  PImage grayscale = img.get();
  grayscale.filter(GRAY);
  
  float[][] horizontalMask = new float[][]{{-1,0,1}, {-2,0,2}, {-1,0,1}};
  float[][] verticalMask = new float[][]{{-1,-2,-1}, {0,0,0}, {1,2,1}};
  
  PImage outputX = applyKernel(grayscale, horizontalMask);  // generates image. mids at 128, negative value at 0, positive value at 255
  PImage outputY = applyKernel(grayscale, verticalMask);  // see above
  PImage output = new PImage(img.width, img.height);
  outputX.loadPixels();
  outputY.loadPixels();
  output.loadPixels();
  
  for (int i = 0; i < output.pixels.length; i++){
    float valueX = inverseLerp(0,255,brightness(outputX.pixels[i])) * 2 - 1;  // obtains x value from -1 to 1 in image
    float valueY = inverseLerp(0,255,brightness(outputY.pixels[i])) * 2 - 1;  // obtains y value from -1 to 1 in image
    float dst = sqrt(valueX*valueX + valueY*valueY); // calculates magnitude from -sqrt2 to sqrt2
    float angle = atan2(valueY,valueX);
    angle = inverseLerp(-PI,PI,angle);
    colorMode(HSB);
    output.pixels[i] = color(angle*(float)256, 255, dst/sqrt(2)*(float)256);
    colorMode(RGB);
  }
  
  output.updatePixels();
  return output;
}
