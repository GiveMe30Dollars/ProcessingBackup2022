import processing.sound.*;

float spawnMargin = 100;

ArrayList<VParticle> particles;
VoronoiSystem sys;
//SoundFile pulse;
//Amplitude amp;

void setup(){
  size(1000,1000);
  //background(200,150,50);
  background(0);
  frameRate(30);
  particles = new ArrayList<VParticle>();
  /*
  pulse = new SoundFile(this,"PulseCut.mp3");
  pulse.play();
  amp = new Amplitude(this);
  amp.input(pulse);*/
  /*
  for (int i = 0; i < 500; i++){
    VParticle p = new VParticle(random(width-spawnMargin*2)+spawnMargin, random(height-spawnMargin*2)+spawnMargin);
    p.col = #222222;
    particles.add(p);
  }*/
  
  recordStart(1800,"Exports/Voroflame.mp4",30);
}

float circleSize = width/3;

void draw(){
  //background(0);
  noTint();
  PImage canvas = get();
  //tint(64,230,128,170);
  //tint(200,150,64,200);
  tint(200,200,200,100);
  //filter(BLUR);
  image(canvas,0,0);
  
  //if (frameCount % 5 == 0) particles.add(new VParticle(random(width-spawnMargin*2)+spawnMargin, random(height-spawnMargin*2)+spawnMargin));
  //if (frameCount < 3450){
  for (int i = 0; i < 4; i++){
    VParticle flame = new VParticle(width/2 + randomGaussian()*15, height/2 + randomGaussian()*15);
    flame.col = #ffff00;
    flame.velocity = PVector.random2D().mult(100);
    //flame.velocity = new PVector(100*cos(frameCount*0.05),100*sin(frameCount*0.05));
    particles.add(flame);
  }
  //}
  sys = new VoronoiSystem(particles);
  sys.generate();
  /*
  for (VCell cell : sys.cells){
    Polygon p = cell.clipped();
    if (p.points.size() <= 0) continue;
    //p.scale(0.9);
    p.crop(2);
    p.chaikinCurve(0.15,3,200);
    
    float furthestDistanceSq = 0;
    for (Transform t : p.points){
      float distanceToCentroid = pow(t.x-p.centroid.x, 2) + pow(t.y-p.centroid.y, 2);
      if (furthestDistanceSq < distanceToCentroid){
        furthestDistanceSq = distanceToCentroid;
      }
    }
    color col = color(255,255,255, max(1000000 / furthestDistanceSq,0));
    //color col = color(255,max(200000 / furthestDistanceSq,0),max(100000 / furthestDistanceSq,0), max(100000 / furthestDistanceSq,0));
    p.show(col,col,0);
    //p.show(#ffffff,#ffffff,0);
    
    //color col = color(255,255,255,16);
    //p.show(col,col,0);
    //for (int i = 0; i < 15; i++){
      //Polygon oldP = (Polygon)p.clone();
      //p.rotate(5);
      //p.scale(0.95);
      //p.clipInverse(oldP);
      //p.show(col,color(255,255,255,32),2);
    //}
  }*/

  PGraphics pg = createGraphics(width,height);
  PGraphics mask = createGraphics(width,height);
  pg.beginDraw();
  mask.beginDraw();
  //mask.background(0);
  for (VParticle p : particles){
    
    VCell cell = null;
    for (VCell v : sys.cells){
      if (v.site == p.ref){
        cell = v;
        break;
      }
    }
    Polygon polygon = cell.clipped();
    p.update(polygon);
    polygon.crop(2);
    polygon.chaikinCurve(0.15,3,100);
    polygon.show(p.col,#ffffff,0,true,pg);
    //polygon.show(#ffffff,#ffffff,0,true,pg);
    polygon.show(#000000,#ffffff,0,true,mask);
    
    polygon.scale(max(min(100/pow(saturation(p.col),1.5),0.9),0.1));
    //polygon.crop(max(0.2*pow(saturation(p.col),1.5),2));
    //polygon.show(#000000,#000000,0);
    polygon.show(#ffffff,#000000,0,true,mask);
    //p.update();
    
    colorMode(HSB);
    p.col = lerpColor(p.col,color(150,22,11,30),0.015);
    colorMode(RGB);
  }
  pg.endDraw();
  mask.endDraw();
  pg.mask(mask);
  noTint();
  image(pg,0,0);
  
  
  for (int i = particles.size()-1; i >= 0; i--){
    VParticle p = particles.get(i);
    if (100/pow(saturation(p.col),1.5) >= 0.85 && abs(randomGaussian()) > 2.0){
      particles.remove(i);
    }
  }
  
  diagnostics();
  recordUpdate();
  
  //float value = abs(sin(frameCount*0.15) + sin(frameCount*0.3))/2;
  //value = min(amp.analyze()*5,1);
  //circleSize = lerp(width/1, width/5, value);
}
