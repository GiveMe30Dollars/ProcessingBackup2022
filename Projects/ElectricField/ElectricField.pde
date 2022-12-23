FieldSystem sys;
float spawnMargin = 200;

PGraphics positive;
PGraphics negative;

void setup(){
  size(1000,1000);
  background(0);
  sys = new FieldSystem();
  //sys.addPole(250,500,10);
  //sys.addPole(750,500,-10);
  //sys.show();
  
  for (int i = 0; i < 75; i++){
    sys.addPole( random(width-2*spawnMargin)+spawnMargin , random(height-2*spawnMargin)+spawnMargin , randomGaussian()*10-2);
  }
  /*
  for (int i = 0; i < 0; i++){
    sys.addParticle(new Charge(random(width),random(height),1));
  }*/
  
  //recordStart(1800,"Exports/WanderingRange.mp4",30);
  
  positive = createGraphics(width,height);
  negative = createGraphics(width,height);
}

void draw(){
  
  PImage canvas = get();
  tint(250,245,200,255);
  //tint(200,245,250,255);
  image(canvas,0,0);
  
  if (frameCount % 1 == 0){
    for (int i = 0; i < 10; i++){
      sys.addParticle(new Charge(random(width),random(height),5));
      //sys.addParticle(new Charge(random(width),random(height),5*Math.signum(random(2)-1)));
      /*
      switch(ceil(random(4))){
        case 1:
          sys.addParticle(new Charge(random(width),random(spawnMargin),1));
          break;
        case 2:
          sys.addParticle(new Charge(random(width),height-random(spawnMargin),1));
          break;
        case 3:
          sys.addParticle(new Charge(random(spawnMargin),random(height),1));
          break;
        case 4:
          sys.addParticle(new Charge(width-random(spawnMargin),random(height),1));
          break;
      }*/
      /*
      switch(ceil(random(4))){
        case 1:
          sys.addParticle(new Charge(random(width),random(spawnMargin),5*Math.signum(random(2)-1)));
          break;
        case 2:
          sys.addParticle(new Charge(random(width),height-random(spawnMargin),5*Math.signum(random(2)-1)));
          break;
        case 3:
          sys.addParticle(new Charge(random(spawnMargin),random(height),5*Math.signum(random(2)-1)));
          break;
        case 4:
          sys.addParticle(new Charge(width-random(spawnMargin),random(height),5*Math.signum(random(2)-1)));
          break;
      }*/
    }
  }
  
  sys.update();
  sys.purge(2);
  sys.show();
  /*
  if (frameCount == 1){
    positive.beginDraw();
    negative.beginDraw();
    sys.show();
    positive.endDraw();
    negative.endDraw();
  }
  
  if (frameCount > 1){
    
    PImage tempP = positive.get();
    PImage tempN = negative.get();
    positive = createGraphics(width,height);
    negative = createGraphics(width,height);
    positive.beginDraw();
    negative.beginDraw();
    positive.tint(250,240,150,255);
    negative.tint(150,240,250,255);
    positive.image(tempP,0,0);
    negative.image(tempN,0,0);
    
    sys.show();
    
    
    positive.endDraw();
    negative.endDraw();
    
    PImage positiveMask = positive.copy();
    PImage negativeMask = negative.copy();
    positiveMask.filter(GRAY);
    negativeMask.filter(GRAY);
    positive.mask(positiveMask);
    negative.mask(negativeMask);
  }
  
  noTint();
  PImage canvas = get();
  background(0);
  //tint(255,255,255,64);
  //image(canvas,0,0);
  //tint(255,255,255,255);
  image(negative,0,0);
  image(positive,0,0);
  image(negative,0,0);
  image(positive,0,0);
  */
  
  for (Charge c : sys.poles){
    //c.move();
  }
  
  circleSize = lerp(width/5, width/8,(sin(frameCount*0.05)+1)/2);
  //print(particles.size()+"\n");
  diagnostics();
  //recordUpdate();
}
