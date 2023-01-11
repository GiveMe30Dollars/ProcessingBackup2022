class Raindrop{
  float x; 
  float y;
  PVector direction;
  float velocity = 0;
  float sediment = 0;
  float water = 1;
  
  boolean enabled = true;
  int steps = 0;
  
  Raindrop(float x_, float y_){
    x = x_;
    y = y_;
    direction = new PVector(0,0);
  }
  
  
  
  void update(float[][] noiseMap, float[][] streamMap){
    if (!enabled) return;    // DO NOTHING IF DISABLED. IDEALLY PARTICLE WOULD BE REMOVED
    
    
    
    // ----- E R O S I O N -----
    
    // CLACLUATE EFFECTIVE PARAMETERS BASED ON STREAMMAP
    float effInertia = inertia * ( 1 - streamInertiaFactor * min(1,getValue(streamMap, x, y)));
    float effEvaporation = evaporation * ( 1 - streamEvaporationFactor * getValue(streamMap, x, y));
    //float effInertia = inertia;
    //float effEvaporation = evaporation;
    
    // GET CURRENT HEIGHT
    float heightCurrent = getValue(noiseMap,x,y);
    
    // CALCULATE GRADIENT
    PVector flowDir = calculateGradient(noiseMap,x,y);
    
    // DIRECTION BASED ON LAST DIRECTION AND GRADIENT
    direction = PVector.sub(direction.mult(effInertia), flowDir.mult(1-effInertia));
    direction.normalize();
    
    // CALCULATE NEW POSITION
    float newX = x + direction.x;
    float newY = y + direction.y;
    
    // GET NEXT HEIGHT
    float heightNext = getValue(noiseMap,newX,newY);
    float heightDiff = heightNext - heightCurrent;
    
    // CALCULATE CARRY CAPACITY
    float c = max(-heightDiff, minSlope) * velocity * water * capacity;
    
    // IF EXCEEDING CAPACITY
    if (sediment > c){
      // DEPOSIT EXCESS
      float depositValue = (sediment - c) * deposition;
      addValue(noiseMap, x, y, depositValue, radius);
      sediment -= depositValue;
    }
    
    // IF TRAVELLING UPHILL
    if (heightDiff >= 0){
      // DEPOSIT SEDIMENT AT OLD POSITION
      float depositValue = min(sediment,heightDiff);
      addValue(noiseMap, x, y, depositValue, radius);
      sediment -= depositValue;
    }
    
    // ELSE ie. TRAVELLING DOWNHILL
    else{
      // ERODE AT OLD POSITION IN RADIUS AND ADD TO PARTICLE
      float erodeValue = min((c-sediment)*erosion, -heightDiff);
      addValue(noiseMap, x, y, -erodeValue, radius);
      sediment += erodeValue;
    }
    
    // ADD TO STREAMMAP
    addValue(streamMap, x, y, streamWrite, streamRadius);
    
    // UPDATE VELOCITY
    velocity = sqrt(velocity*velocity + heightDiff*gravity);
    // UPDATE WATER
    water *= (1-effEvaporation);
    // UPDATE POSITION
    x = newX;
    y = newY;
    
    // ----- F I N -----
    
    
    
    // DISABLE PARTICLE
    if (x < 2 || x >= noiseMap[0].length-2 || y < 2 || y >= noiseMap.length-2) enabled = false;    // OUT OF BOUNDS
    if (water <= 0){
      enabled = false;    // NO MORE WATER
      addValue(noiseMap, x, y, sediment, radius);
    }
    steps++;
    if (steps > maxSteps) enabled = false;    // MAX STEPS EXCEEDED
  }
  
  
  
  void show(){
    noStroke();
    color c = color(0,155,255,200);
    float size = lerp(2,8,water);
    fill(c);
    circle(x,y,size);
  }
}
