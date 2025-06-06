PVector calculateGradient(float[][] noiseMap, float x, float y){
  int x_ = floor(x);
  int y_ = floor(y);
  float deltaX = x-x_;
  float deltaY = y-y_;
  
  float topLeft = noiseMap[x_][y_];
  float topRight = noiseMap[x_+1][y_];
  float bottomLeft = noiseMap[x_][y_+1];
  float bottomRight = noiseMap[x_+1][y_+1];
  
  float forceX = lerp(topRight-topLeft, bottomRight-bottomLeft, deltaY);
  float forceY = lerp(bottomLeft-topLeft, bottomRight-topRight, deltaX);
  
  return new PVector(forceX, forceY);
}


ArrayList<float[]> getCellsInCircle(float[][] noiseMap, float x, float y, float r){
  ArrayList<float[]> cells = new ArrayList<float[]>();
  
  // BOUNDING BOX
  int lowerBoundX = max(0, floor(x-r));
  int upperBoundX = min(noiseMap[0].length-1, ceil(x+r));
  int lowerBoundY = max(0, floor(y-r));
  int upperBoundY = min(noiseMap.length-1, ceil(y+r));
  
  for (int cellY = lowerBoundY; cellY <= upperBoundY; cellY++){
    for (int cellX = lowerBoundX; cellX <= upperBoundX; cellX++){
      float dx = (float)cellX + 0.5f - x;
      float dy = (float)cellY + 0.5f - y;
      float distanceSqr = dx*dx + dy*dy;
      if (distanceSqr <= r*r){
        // CELL IN CIRCLE, SAVE INDEX
        cells.add(new float[]{cellX, cellY, sqrt(distanceSqr)});
      }
    }
  }
  
  return cells;
}


float getValue(float[][] noiseMap, float x, float y){
  int x_ = floor(x);
  int y_ = floor(y);
  float deltaX = x-x_;
  float deltaY = y-y_;
  
  float topLeft = noiseMap[x_][y_];
  float topRight = noiseMap[x_+1][y_];
  float bottomLeft = noiseMap[x_][y_+1];
  float bottomRight = noiseMap[x_+1][y_+1];
  
  float valTop = lerp(topLeft, topRight, deltaX);
  float valBottom = lerp(bottomLeft, bottomRight, deltaX);
  float valAll = lerp(valTop, valBottom, deltaY);
  
  return valAll;
}


void addValue(float[][] noiseMap, float x, float y, float val){
  int x_ = floor(x);
  int y_ = floor(y);
  float deltaX = x-x_;
  float deltaY = y-y_;
  
  noiseMap[x_][y_] += val * (1-deltaX) * (1-deltaY);    // TOP LEFT
  noiseMap[x_+1][y_] += val * deltaX * (1-deltaY);    // TOP RIGHT
  noiseMap[x_][y_+1] += val * (1-deltaX) * deltaY;    // BOTTOM LEFT
  noiseMap[x_+1][y_+1] += val * deltaX * deltaY;    // BOTTOM RIGHT
}


void addValue(float[][] noiseMap, float x, float y, float val, float radius){
  ArrayList<float[]> cells = getCellsInCircle(noiseMap, x, y, radius);
  float[] weights = new float[cells.size()];
  float totalWeight = 0;
  
  for (int i = 0; i < weights.length; i++){
    float[] cell = cells.get(i);
    float distance = cell[2];
    float weight = max(0, radius - distance);
    weights[i] = weight;
    totalWeight += weight;
  }
  
  for (int i = 0; i < weights.length; i++){
    weights[i] /= totalWeight;
    int cellX = (int)cells.get(i)[0];
    int cellY = (int)cells.get(i)[1];
    noiseMap[cellX][cellY] += val*weights[i];
  }
}
