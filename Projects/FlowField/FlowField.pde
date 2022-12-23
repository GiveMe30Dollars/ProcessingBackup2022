class Particle{
  
  PVector position, velocity;
  int seed;
  
  Particle(float x, float y, int s){
    position = new PVector(x,y);
    velocity = new PVector(0,0);
    seed = s;
  }
  
  void Update(){
    noiseSeed(seed);
    PVector previous = new PVector(position.x,position.y);
    velocity = PVector.fromAngle(noise(position.x*0.01,position.y*0.01)*2*PI);
    velocity.mult(2);
    position.add(velocity);
    line(position.x,position.y,previous.x,previous.y);
  }
  
  boolean IsOutOfBounds(){
    if (position.x < 0 || position.x > width || position.y < 0 || position.y > width) return true;
    else return false;
  }
}


ArrayList<Particle> particles = new ArrayList<Particle>();
boolean screenshotted = false;

void setup(){
  size(500,500);
  background(0);
  stroke(255,1);
  strokeWeight(1);
  /*
  for (int i = 0; i < 10000; i++){
    particles.add(new Particle(random(width), random(height),0));
  }*/
  for (int y = 0; y < height; y++){
    for (int x = 0; x < width; x++){
      particles.add(new Particle(x, y,0));
    }
  }
  
}

void draw(){
  for (int i = 0; i < particles.size(); i++){
    Particle particle = particles.get(i);
    particle.Update();
    if (particle.IsOutOfBounds()) {
      particles.remove(i);
      i--;
    }
  } 
  if (particles.size() == 0){
    if (!screenshotted){
      screenshotted = true;
      print("Render Complete.");
      save("Blurry.png");
    }
  }
}


/*
ArrayList<Bulb> bulbs = new ArrayList<Bulb>();
ArrayList<int[]> colors = new ArrayList<int[]>();
boolean screenshotted = false;

void setup(){
  size(1000,1000);
  background(255,255,250);
  strokeWeight(2);
  stroke(255, 32);
  noFill();
  
  for (int i = 0; i < 75; i++){
    float x = random(width);
    float y = random(height);
    float r = random(5,15);
    int colorChoice = round(random(4));
    int[] c = new int[3];
    switch (colorChoice){
      case 0:
        c[0] = 15;
        c[1] = 15;
        c[2] = 15;
        break;
      case 1:
        c[0] = 255;
        c[1] = 0;
        c[2] = 0;
        break;
      case 2:
        c[0] = 255;
        c[1] = 186;
        c[2] = 0;
        break;
      case 3:
        c[0] = 0;
        c[1] = 107;
        c[2] = 19;
        break;
      case 4:
        c[0] = 0;
        c[1] = 46;
        c[2] = 163;
        break;
    }
    
    bulbs.add(new Bulb(x,y,r,0,4));
    //noFill();
    fill(c[0],c[1],c[2]);
    stroke(c[0],c[1],c[2],63);
    bulbs.get(i).DrawCircle();
    colors.add(c);
  }
  
  strokeWeight(2);
  stroke(255,10);
}

void draw(){
  for (int i = 0; i < bulbs.size(); i++){
    stroke(colors.get(i)[0],colors.get(i)[1],colors.get(i)[2],32);
    Bulb bulb = bulbs.get(i);
    bulb.Update();
    if (bulb.IsOutOfBounds()) {
      bulbs.remove(i);
      colors.remove(i);
      i--;
    }
  }
  if (bulbs.size() == 0){
    if (!screenshotted){
      screenshotted = true;
      print("Render Complete.");
      save("FloweringBulbs.png");
    }
  }
}
*/
