class CASystem{
  int[][] now;
  int[][] next; 
  int w = 500;
  int h = 500;
  int range = 1;
  float survivalA = 2;
  float survivalB = 3;
  float birthA = 3;
  float birthB = 3;
  boolean usePercentage = false;
  
  CASystem(int w_, int h_, float spawnPercentage){
    w = w_;
    h = h_;
    now = new int[w][h];
    next = new int[w][h];
    for (int y = 0; y < h; y++){
      for (int x = 0; x < w; x++){
        now[x][y] = random(1) < spawnPercentage ? 1 : 0;
      }
    }
  }
  
  void addRules(int r_, float sA_, float sB_, float bA_, float bB_, boolean uP_){
    range = r_;
    survivalA = sA_;
    survivalB = sB_;
    birthA = bA_;
    birthB = bB_;
    usePercentage = uP_;
  }
  
  void update(){
    for (int y = 0; y < h; y++){
      for (int x = 0; x < w; x++){
        int neighbours = 0;
        int total = 0;
        for (int q = -range; q <= range; q++){
          for (int p = -range; p <= range; p++){
            if (p == 0 && q == 0) continue;
            if (x+p < 0 || x+p >= w || y+q < 0 || y+q >= h){
              neighbours++;
              total++;
              continue;
            }
            neighbours += now[x+p][y+q];
            total++;
          }
        }
        float value = neighbours;
        if (usePercentage) value /= total;
        next[x][y] = 0;
        if (survivalA <= value && value <= survivalB) next[x][y] = now[x][y];    // SURVIVAL
        if (birthA <= value && value <= birthB) next[x][y] = 1;    // BIRTH
      }
    }
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
