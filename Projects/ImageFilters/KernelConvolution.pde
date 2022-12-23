PImage applyKernel(PImage img, float[][] kernel){
  PImage output = new PImage(img.width, img.height);
  img.loadPixels();
  output.loadPixels();
  
  int rx = floor( (kernel.length-1)/2 );
  int ry = floor( (kernel[0].length-1)/2 );
  
  for (int y = 0; y < img.height; y++){
    for (int x = 0; x < img.width; x++){
      
      float[] totalValue = new float[3];
      float totalWeight = 0;
      
      for (int ky = 0; ky < kernel[0].length; ky++){
        for (int kx = 0; kx < kernel.length; kx++){
          
          int indexX = x + kx - rx;
          int indexY = y + ky - ry;
          if (indexX < 0 || indexX >= img.width) continue;
          if (indexY < 0 || indexY >= img.height) continue;
          
          int index = indexY * img.width + indexX;
          totalValue[0] += red(img.pixels[index]) * kernel[kx][ky];
          totalValue[1] += green(img.pixels[index]) * kernel[kx][ky];
          totalValue[2] += blue(img.pixels[index]) * kernel[kx][ky];
          totalWeight += kernel[kx][ky];
          
        }
      }
      color c;
      if (totalWeight == 0){   // exception for encoding sobel operatior edge detection values
        c = color(floor(totalValue[0]+128), 
                  floor(totalValue[1]+128), 
                  floor(totalValue[2]+128));
      }
      else {
        c = color(floor(totalValue[0]/totalWeight), 
                  floor(totalValue[1]/totalWeight), 
                  floor(totalValue[2]/totalWeight));
      }
      output.pixels[y*img.width+x] = c;
      
    }
  }
  output.updatePixels();
  return output;
}
