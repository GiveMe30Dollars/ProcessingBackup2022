PImage meanBlur(PImage img, int x, int y){
  img.loadPixels();
  
  int sizeX = 2 * x + 1;
  int sizeY = 2 * y + 1;
  float[][] kernelX = new float[sizeX][1];
  float[][] kernelY = new float[1][sizeY];
  
  for (int i = 0; i < sizeX; i++){
    kernelX[i][0] = 1;
  }
  
  for (int i = 0; i < sizeY; i++){
    kernelY[0][i] = 1;
  }
  
  PImage intermediate = applyKernel(img, kernelX);
  PImage output = applyKernel(intermediate, kernelY);
  return output;
}

PImage meanBlur(PImage img, int r){
  return meanBlur(img, r, r);
}



PImage gaussianBlur(PImage img, int x, int y, float sigma){
  img.loadPixels();
  
  int sizeX = 2 * x + 1;
  int sizeY = 2 * y + 1;
  float[][] kernelX = new float[sizeX][1];
  float[][] kernelY = new float[1][sizeY];
  
  for (int i = 0; i < sizeX; i++){
    int valueX = i-x;
    kernelX[i][0] = exp(-(valueX*valueX)/(2*sigma*sigma));
  }
  
  for (int i = 0; i < sizeY; i++){
    int valueY = i-y;
    kernelY[0][i] = exp(-(valueY*valueY)/(2*sigma*sigma));
  }
  
  PImage intermediate = applyKernel(img, kernelX);
  PImage output = applyKernel(intermediate, kernelY);
  return output;
}

PImage gaussianBlur(PImage img, int r, float sigma){
  return gaussianBlur(img, r, r, sigma);
}
