void view2D(float[][] heightMap){
  loadPixels();
  for (int y = 0; y < height; y++){
    for (int x = 0; x < width; x++){
      pixels[y*width+x] = color(heightMap[x][y]*256);
    }
  }
  updatePixels();
}


float xRotation = PI/3;
float zRotation = PI/4;
float xVel = 0;
float zVel = 0;

float threshold = 0.002;
float blendAmt = 0.0025;


void view3D(){
  
  translate(width/2, height/2,-650);
  rotateX(xRotation);
  rotateZ(zRotation);
  translate(-width/2, -height/2);
  
  colorMode(RGB);
  lights();
  //ambientLight(255,255,220);
  directionalLight(255, 255, 220, 1, 1, 0);
  directionalLight(255,255,255,1,0,0);
  noStroke();
  
  color soil = #75554f;
  //color grass = #ffffff;
  color grass = #bbbbbb;
  color darkness = #050020;
  color water = #ccddfe;
  fill(128);
  
  for (int y = 0; y < noiseMap.length-1; y++){
    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < noiseMap[0].length; x++){
      // HEIGHT COLOR
      //fill(lerp(0,255,noiseMap[x][y]*noiseMap[x][y]));
      /*
      // EROSION DIFFERENCE COLOR
      colorMode(HSB);
      float diff = original[x][y] - noiseMap[x][y];
      color c = color(150, diff*1000, noiseMap[x][y]*255);
      fill(c);*/
      /*
      // GRADIENT AND HEIGHT COLOR
      if(x >= noiseMap[0].length-1 || y >= noiseMap.length-1){
        vertex(x*2, y*2, noiseMap[x][y]*400-100);
        vertex(x*2, (y+1)*2, noiseMap[x][y+1]*400-100);
        continue;
      }
      PVector gradient = calculateGradient(noiseMap,(float)x+0.5, (float)y+0.5);
      float gradientMag = gradient.mag();
      color c;
      if (gradientMag < threshold - blendAmt) c = grass;
      else if (gradientMag > threshold + blendAmt) c = soil;
      else {
        float lerpVal = inverseLerp(threshold-blendAmt, threshold+blendAmt, gradientMag);
        c = lerpColor(grass, soil, lerpVal);
      }
      
      fill(lerpColor(#050020, c, noiseMap[x][y]));*/
      
      // STREAM AND HEIGHT COLOR
      if(x >= noiseMap[0].length-1 || y >= noiseMap.length-1){
        vertex(x*2, y*2, noiseMap[x][y]*400-50);
        vertex(x*2, (y+1)*2, noiseMap[x][y+1]*400-50);
        continue;
      }
      PVector gradient = calculateGradient(noiseMap,(float)x+0.5, (float)y+0.5);
      float gradientMag = gradient.mag();
      color c;
      color d;
      /*
      if (gradientMag < threshold - blendAmt) c = grass;
      else if (gradientMag > threshold + blendAmt) c = soil;
      else {
        float lerpVal = inverseLerp(threshold-blendAmt, threshold+blendAmt, gradientMag);
        c = lerpColor(grass, soil, lerpVal);
      }*/
      c = soil;
      d = lerpColor(darkness, c, noiseMap[x][y]);
      fill(lerpColor(d, water, streamMap[x][y]));
      
      vertex(x*2, y*2, noiseMap[x][y]*400-50);
      vertex(x*2, (y+1)*2, noiseMap[x][y+1]*400-50);
      
    }
    endShape();
  }
}
