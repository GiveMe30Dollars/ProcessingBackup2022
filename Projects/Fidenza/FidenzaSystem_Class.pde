class FidenzaSystem{
  ArrayList<FidenzaStrip> strips;
  float maxRadius = 0;
  FidenzaSystem(){
    strips = new ArrayList<FidenzaStrip>();
  }
  
  void addStrip(FidenzaStrip strip){
    strips.add(strip);
  }
  
  void addStrip(float lowerValue, float upperValue, float minRadius, float midRadius, float bigRadius){
    float value = random(1);
    float radius = 0;
    if (value < lowerValue) radius = minRadius;
    else if (value < upperValue) radius = midRadius;
    else radius = bigRadius;
    FidenzaStrip strip = new FidenzaStrip(random(width+canvasMargin*2)-canvasMargin, random(height+canvasMargin*2)-canvasMargin, radius);
    strip.lifetime = lifetime;
    strips.add(strip);
    maxRadius = max(bigRadius, maxRadius);
  }
  void addStrip(){
    addStrip(0.2, 0.9, 5, 20, 50);
  }
  void addStrip(String modifier){
    switch (modifier){
      case "MICRO":
        addStrip(1,1,3,3,3);
        break;
      case "MACRO":
        addStrip(0, 0.7, 5, 50, 75);
        break;
      case "REGULAR":
        addStrip(0.5, 0.9, 5, 20, 35);
        break;
      case "BIG":
        addStrip(0.3, 0.75, 10, 25, 50);
        break;
      case "JUMBO":
        addStrip(0.2, 0.55, 10, 25, 50);
        break;
    }
  }
  
  void update(){
    for (FidenzaStrip strip : strips){
      strip.update(scale, seed);
      strip.checkCollision(strips, maxRadius);
    }
  }
  
  void show(){
    for (FidenzaStrip strip : strips){
      strip.show();
    }
  }
  
  void show(color c){
    for (FidenzaStrip strip : strips){
      strip.show(c);
    }
  }
}
