class Cell{
  
  float a;
  float b;
  
  Cell(float a_, float b_){
    a = a_;
    b = b_;
  }
}

Cell reactionDiffusion(Cell[][] grid, int x, int y){
  float a = grid[x][y].a;
  float b = grid[x][y].b;
  
  float newA = a + (diffusionRateA * laplaceA(grid, x, y) - a*b*b + feedRate*(1-a));
  float newB = b + (diffusionRateB * laplaceB(grid, x, y) + a*b*b -(killRate+feedRate)*b);
  
  newA = Math.max(0, Math.min(1, newA));
  newB = Math.max(0, Math.min(1, newB));
  
  return new Cell(newA, newB);
}

float laplaceA(Cell[][] grid, int x, int y){
  float value = 0;
  
  value += grid[x][y].a * -1;
  
  value += grid[x-1][y].a * 0.2;
  value += grid[x+1][y].a * 0.2;
  value += grid[x][y-1].a * 0.2;
  value += grid[x][y+1].a * 0.2;
  
  value += grid[x-1][y-1].a * 0.05;
  value += grid[x+1][y-1].a * 0.05;
  value += grid[x-1][y+1].a * 0.05;
  value += grid[x+1][y+1].a * 0.05;
  
  return value;
}

float laplaceB(Cell[][] grid, int x, int y){
  float value = 0;
  
  value += grid[x][y].b * -1;
  
  value += grid[x-1][y].b * 0.2;
  value += grid[x+1][y].b * 0.2;
  value += grid[x][y-1].b * 0.2;
  value += grid[x][y+1].b * 0.2;
  
  value += grid[x-1][y-1].b * 0.05;
  value += grid[x+1][y-1].b * 0.05;
  value += grid[x-1][y+1].b * 0.05;
  value += grid[x+1][y+1].b * 0.05;
  
  return value;
}
