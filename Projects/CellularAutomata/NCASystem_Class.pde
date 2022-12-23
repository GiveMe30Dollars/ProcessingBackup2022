class NCASystem{
  int w; int h;
  float[][] now;
  float[][] next;
  float[][] weights;
  boolean usePercentage = false;
  
  NCASystem(int w_, int h_, float spawnPercentage){
    w = w_;
    h = h_;
    now = new float[w][h];
    next = new float[w][h];
    for (int y = 0; y < h; y++){
      for (int x = 0; x < w; x++){
        now[x][y] = random(2)-1;
      }
    }
    weights = new float[][]{ {0.8,-0.4,0.8},
                             {-0.4,0.5,-0.4},
                             {0.8,-0.4,0.8} };
    // RANDOM WEIGHTS
    /*
    for (int y = 0; y <= 2; y++){
      for (int x = 0; x <= 2; x++){
        weights[x][y] = random(2)-1;
      }
    }*/
    
    // SYMETRICAL WEIGHTS
    /*
    weights[1][1] = random(2)-1;
    float edgeW = random(2)-1;
    weights[0][1] = edgeW;
    weights[1][0] = edgeW;
    weights[2][1] = edgeW;
    weights[1][2] = edgeW;
    float cornerW = random(2)-1;
    weights[0][0] = cornerW;
    weights[2][0] = cornerW;
    weights[2][2] = cornerW;
    weights[0][2] = cornerW;*/
    
    // SET WEIGHTS
    
    weights[1][1] = 0.44122887;
    float edgeW = -0.55195224;
    weights[0][1] = edgeW;
    weights[1][0] = edgeW;
    weights[2][1] = edgeW;
    weights[1][2] = edgeW;
    float cornerW = -0.57734656;
    weights[0][0] = cornerW;
    weights[2][0] = cornerW;
    weights[2][2] = cornerW;
    weights[0][2] = cornerW;
  }
  
  void update(){
    for (int y = 0; y < h; y++){
      for (int x = 0; x < w; x++){
        float neighbours = 0;
        int total = 0;
        for (int q = -1; q <= 1; q++){
          for (int p = -1; p <= 1; p++){
            //if (p == 0 && q == 0) continue;
            if (x+p < 0 || x+p >= w || y+q < 0 || y+q >= h){
              neighbours += weights[p+1][q+1];
              //total++;
              continue;
            }
            neighbours += now[x+p][y+q] * weights[p+1][q+1];
            total++;
          }
        }
        float value = neighbours;
        if (usePercentage) value /= total;
        next[x][y] = activation(value);
      }
    }
  }
  
  float activation(float val){
    //return 1 - 1/(pow(2,val*val)*0.89+1);
    //return abs(sin(val));
    //return 1/(1-abs(val)) + 1;
    //return max(0,min(val*val,1));
    //return max(0,min(val,1));
    //return atan(val);
    //return abs(val);
    //return max(-300000,min(abs(val),300000));
    //return abs(cos(val));
    //return val;
  }
  
  void show(color col){
    PImage display = createImage(w, h, ARGB);
    display.loadPixels();
    for (int y = 0; y < h; y++){
      for (int x = 0; x < w; x++){
        now[x][y] = next[x][y];
        display.pixels[y * w + x] = lerpColor(color(0,0,0,0),col,now[x][y]);
      }
    }
    display.updatePixels();
    image(resizeImage(display,width,height),0,0);
  }
  void show(){
    show(#ffffff);
  }
}
