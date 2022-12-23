class Superpixel{
  color c;
  float x;
  float y;
  int j;
  Superpixel(color c_, float x_, float y_, int j_){
    x = x_;
    y = y_;
    c = c_;
    j = j_;
  }
}


int indexOfClosestSuperpixel(color c, float x, float y, Superpixel[] sPixels, float m, float s){  // returns the color in array that closest matchs the imput
  int indexOfClosestSuperpixel = 0;
  float lowestWeight = Float.POSITIVE_INFINITY;
  for(int j = 0; j < sPixels.length; j++){
    color diffColor = difference(c, sPixels[j].c);
    PVector diffDst = new PVector(x-sPixels[j].x, y-sPixels[j].y);
    
    float weight = sqrt(colorDstSqr(diffColor)) + m/s * diffDst.mag();
    if (weight < lowestWeight){
      lowestWeight = weight;
      indexOfClosestSuperpixel = j;
    }
  }
  return indexOfClosestSuperpixel;
}


Superpixel[] randomSuperpixels(PImage img, int k){
  Superpixel[] sPixels = new Superpixel[k];
  for (int j = 0; j < k; j++){  // select random colors in picture as starting cluster
    int x = (int)random(img.width);
    int y = (int)random(img.height);
    color c = img.pixels[y*img.width+x];
    sPixels[j] = new Superpixel(c, x, y, j);
  }
  return sPixels;
}


Superpixel[] SLICIterative(PImage img, Superpixel[] sPixels, float m, PImage output){
  
  float s = sqrt((float)img.pixels.length / sPixels.length);
  
  Superpixel[] newSuperpixels = new Superpixel[sPixels.length];
  float[][] sPixelValues = new float[sPixels.length][6]; // store cluster average value; 0: red, 1: blue, 2: green, 3: x, 4: y, 5: amount
  
  for(int y = 0; y < img.height; y++){
     for(int x = 0; x < img.width; x++){
        
       int i = y*img.width+x;
       int indexOfClosestSuperpixel = indexOfClosestSuperpixel(img.pixels[i], x, y, sPixels, m, s);
       
       if (output != null) output.pixels[i] = sPixels[indexOfClosestSuperpixel].c;
       
       sPixelValues[indexOfClosestSuperpixel][0] += red(img.pixels[i]);
       sPixelValues[indexOfClosestSuperpixel][1] += green(img.pixels[i]);
       sPixelValues[indexOfClosestSuperpixel][2] += blue(img.pixels[i]);
       sPixelValues[indexOfClosestSuperpixel][3] += x;
       sPixelValues[indexOfClosestSuperpixel][4] += y;
       sPixelValues[indexOfClosestSuperpixel][5] ++;
        
    }
  }
  
  for (int j = 0; j < newSuperpixels.length; j++){
    float[] values = sPixelValues[j];
    color c = color(values[0]/values[5], values[1]/values[5], values[2]/values[5]);
    float x = values[3]/values[5];
    float y = values[4]/values[5];
    newSuperpixels[j] = new Superpixel(c,x,y,j);
  }
  
  return newSuperpixels;
}
