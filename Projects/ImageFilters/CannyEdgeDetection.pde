/*
PImage edgeThinning(PImage sobel){
  PImage output = new PImage(sobel.width, sobel.height);
  sobel.loadPixels();
  output.loadPixels();
  
  for (int y = 0; y < output.height; y++){
    for (int x = 0; x < output.width; x++){
      int i = y * output.width + x;
      float angle = hue(sobel.pixels[i]) / 255 * 360;
      if (angle > 180) angle -= 180;
      int[] coordsP = new int[2];
      int[] coordsQ = new int[2];
      //float h = 0;
      
      
      if ((0 <= angle && angle < 22.5) || (157.5 <= angle && angle <= 180)){
        coordsP[0] = x;  coordsP[1] = y+1;
        coordsQ[0] = x;  coordsQ[1] = y-1;
        //h = 0;
      }
      else if (22.5 <= angle && angle < 67.5){
        
        coordsP[0] = x-1;  coordsP[1] = y-1;
        coordsQ[0] = x+1;  coordsQ[1] = y+1;
        //h = 50;
      }
      else if (67.5 <= angle && angle < 112.5){
        coordsP[0] = x+1;  coordsP[1] = y;
        coordsQ[0] = x-1;  coordsQ[1] = y;
        //h = 100;
      }
      else if (112.5 <= angle && angle < 157.5){
        
        coordsP[0] = x+1;  coordsP[1] = y-1;
        coordsQ[0] = x-1;  coordsQ[1] = y+1;
        //h = 150;
      }
      
      float valueP;
      float valueQ;
      if (coordsP[0] < 0 || coordsP[0] >= sobel.width || coordsP[1] < 0 || coordsP[1] >= sobel.height) valueP = 0;
      else valueP = brightness( sobel.pixels[coordsP[1] * sobel.width + coordsP[0]] );
      if (coordsQ[0] < 0 || coordsQ[0] >= sobel.width || coordsQ[1] < 0 || coordsQ[1] >= sobel.height) valueQ = 0;
      else valueQ = brightness( sobel.pixels[coordsQ[1] * sobel.width + coordsQ[0]] );
      
      
      float value = brightness(sobel.pixels[i]);
      //colorMode(HSB);
      if (valueP <= value && valueQ <= value){
        //output.pixels[i] = color(h,255,value);
        output.pixels[i] = color(value);
      }
      else output.pixels[i] = color(value*0);
      //colorMode(RGB);
    }
  }  
  
  output.updatePixels();
  return output;
}
*/


PImage edgeThinning(PImage sobel){
  PImage output = new PImage(sobel.width, sobel.height);
  sobel.loadPixels();
  output.loadPixels();
  
  for (int y = 0; y < output.height; y++){
    for (int x = 0; x < output.width; x++){
      int i = y * output.width + x;
      float angle = hue(sobel.pixels[i]) / 256 * 360;
      if (angle > 180) angle -= 180;
      float weight = 0;
      int angleGroup = 0;
      int[] coordsPa = new int[2];
      int[] coordsQa = new int[2];
      int[] coordsPb = new int[2];
      int[] coordsQb = new int[2];
      
      if (0 <= angle && angle < 45){
        coordsPa[0] = x;  coordsPa[1] = y+1;
        coordsQa[0] = x;  coordsQa[1] = y-1;
        
        coordsPb[0] = x+1;  coordsPb[1] = y+1;
        coordsQb[0] = x-1;  coordsQb[1] = y-1;
        
        weight = inverseLerp(0,45,angle);
        angleGroup = 0;
      }
      else if (45 <= angle && angle < 90){
        coordsPa[0] = x+1;  coordsPa[1] = y+1;
        coordsQa[0] = x-1;  coordsQa[1] = y-1;
        
        coordsPb[0] = x+1;  coordsPb[1] = y;
        coordsQb[0] = x-1;  coordsQb[1] = y;
        
        weight = inverseLerp(45,90,angle);
        angleGroup = 45;
      }
      else if (90 <= angle && angle < 135){
        coordsPa[0] = x+1;  coordsPa[1] = y;
        coordsQa[0] = x-1;  coordsQa[1] = y;
        
        coordsPb[0] = x+1;  coordsPb[1] = y-1;
        coordsQb[0] = x-1;  coordsQb[1] = y+1;
        
        weight = inverseLerp(90,135,angle);
        angleGroup = 90;
      }
      else if (135 <= angle && angle < 180){
        coordsPa[0] = x+1;  coordsPa[1] = y-1;
        coordsQa[0] = x-1;  coordsQa[1] = y+1;
        
        coordsPb[0] = x;  coordsPb[1] = y-1;
        coordsQb[0] = x;  coordsQb[1] = y+1;
        
        weight = inverseLerp(135,180,angle);
        angleGroup = 135;
      }
      
      int indexPa = coordsPa[1] * sobel.width + coordsPa[0];
      int indexQa = coordsQa[1] * sobel.width + coordsQa[0];
      int indexPb = coordsPb[1] * sobel.width + coordsPb[0];
      int indexQb = coordsQb[1] * sobel.width + coordsQb[0];
      
      float valuePa;
      float valueQa;
      float valuePb;
      float valueQb;
      
      if (indexPa < 0 || indexPa >= sobel.pixels.length) valuePa = 0;
      else valuePa = brightness(sobel.pixels[indexPa]);
      
      if (indexQa < 0 || indexQa >= sobel.pixels.length) valueQa = 0;
      else valueQa = brightness(sobel.pixels[indexQa]);
      
      if (indexPb < 0 || indexPb >= sobel.pixels.length) valuePb = 0;
      else valuePb = brightness(sobel.pixels[indexPb]);
      
      if (indexQb < 0 || indexQb >= sobel.pixels.length) valueQb = 0;
      else valueQb = brightness(sobel.pixels[indexQb]);
      
      float valueP = lerp(valuePa, valuePb, weight);
      float valueQ = lerp(valueQa, valueQb, weight);
      
      float value = brightness(sobel.pixels[i]);
      if (valueP <= value && valueQ <= value){
        output.pixels[i] = color(value);
      }
      else output.pixels[i] = color(0);
    }
  }  
  
  output.updatePixels();
  return output;
}



PImage doubleThreshold(PImage img, float lowThreshold, float highThreshold){
  PImage output = new PImage(img.width, img.height);
  img.loadPixels();
  output.loadPixels();
  
  float low = lowThreshold * 256;
  float high = highThreshold * 256;
  
  for (int i = 0; i < output.pixels.length; i++){
    float b = brightness(img.pixels[i]);
    if (b < low) output.pixels[i] = color(0);
    else if(b >= high) output.pixels[i] = color(255);
    else output.pixels[i] = color(128);
  }
  
  output.updatePixels();
  return output;
}



PImage hysteresis(PImage img){
  PImage output = img.get();
  img.loadPixels();
  output.loadPixels();
  
  for (int y = 0; y < output.height; y++){
    for (int x = 0; x < output.width; x++){
      
      int index = y * output.width + x;
      if (brightness(img.pixels[index]) == 0 || brightness(img.pixels[index]) == 255) continue;
      
      kernel:
      for (int j = -1; j <= 1; j++){
        for (int i = -1; i <= 1; i++){
          int neighbourIndex = (y+j) * output.width + (x+i);
          if (neighbourIndex < 0 || neighbourIndex >= img.pixels.length) continue;
          else if (brightness(img.pixels[neighbourIndex]) == 255){
            output.pixels[index] = color(255);
            break kernel;
          }
        }
      }
      
      if (brightness(output.pixels[index]) != 255){
        output.pixels[index] = color(0);
      }
      
    }
  }
  
  output.updatePixels();
  return output;
}



PImage cannyEdgeDetector(PImage img, float lowThreshold, float highThreshold){
  PImage sobel = sobelOperatorColor(img);
  PImage thinEdges = edgeThinning(sobel);
  PImage doubleThreshold = doubleThreshold(thinEdges, lowThreshold, highThreshold);
  PImage output = hysteresis(doubleThreshold);
  return output;
}
PImage cannyEdgeDetector(PImage img){
  return cannyEdgeDetector(img,0.1,0.3);
}
