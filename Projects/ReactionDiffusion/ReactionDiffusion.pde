Cell[][] grid;
Cell[][] next;

float diffusionRateA = 1.0;
float diffusionRateB = 0.5;
float feedRate = 0.055;
float killRate = 0.062;

int mouseRange = 5;


int frameLimit = 4800;
int startSize = 5;

void setup(){
  size(1000,1000);
  grid = new Cell[width][height];
  for (int y = 0; y < height; y++){
    for (int x = 0; x < width; x++){
      grid[x][y] = new Cell(1,0);
      //grid[x][y] = new Cell(1,random(0.3));
      //grid[x][y] = new Cell(1,1);
    }
  }
  
  for (int y = height/2-startSize; y < height/2+startSize; y++){    // CENTRE SEED
    for (int x = width/2-startSize; x < width/2+startSize; x++){
      grid[x][y] = new Cell(1,1);
    }
  }
  
  for(int i = 0; i < 1500; i++){      // RANDOM SEEDS
    int xOffset = floor(random(width-2*startSize)) + startSize;
    int yOffset = floor(random(height-2*startSize)) + startSize;
    for (int y = xOffset-startSize; y < xOffset+startSize; y++){
      for (int x = yOffset-startSize; x < yOffset+startSize; x++){
        grid[x][y] = new Cell(1,1);
      }
    }
  }
  next = grid.clone();
}

void draw(){
  background(0);
  loadPixels();
  for (int j = 0; j < 5; j++){
  for (int y = 1; y < height-1; y++){
    for (int x = 1; x < width-1; x++){
      killRate = lerp(0.045, 0.07, (float)x/width);
      feedRate = lerp(0.01, 0.1, (float)y/height);
      next[x][y] = reactionDiffusion(grid, x, y);
      //pixels[y*width+x] = color((next[x][y].a-next[x][y].b)*255);
      
      float[] values = heatGradient(clamp(0, 1, next[x][y].a-next[x][y].b));
      pixels[y*width+x] = color(values[0], values[1], values[2]);
    }
  }
  }
  updatePixels();
  grid = next.clone();
  //print(frameCount+"\n");
  /*
  print(frameCount + "       " + frameRate + "\n");
  saveFrame("DistributionGrayscale/frame_####.png");
  if (frameCount >= frameLimit) noLoop();*/
}
/*
void mousePressed(){
  for (int y = max(mouseY-mouseRange, 1); y < min(mouseY+mouseRange, height-1); y++){
    for (int x = max(mouseX-mouseRange, 1); x < min(mouseX+mouseRange, width-1); x++){
      grid[x][y].b = 1;
    }
  }
}

void mouseDragged(){
  for (int y = max(mouseY-mouseRange, 1); y < min(mouseY+mouseRange, height-1); y++){
    for (int x = max(mouseX-mouseRange, 1); x < min(mouseX+mouseRange, width-1); x++){
      grid[x][y].b = 1;
    }
  }
}*/

void keyPressed(){
  if (key == ENTER){
    save("Distribution.png");
  }
}
