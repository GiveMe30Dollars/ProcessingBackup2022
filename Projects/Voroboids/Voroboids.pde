//ArrayList<Boid> boids;
ArrayList<Firefloid> ffloids;
//Quadtree<Boid> qTree;
Quadtree<Firefloid> qTree;
VoronoiSystem sys;

void setup(){
  size(1000,1000);
  background(0);
  //boids = new ArrayList<Boid>();
  ffloids = new ArrayList<Firefloid>();
  for(int i = 0; i < 0; i++){
    //boids.add(new Boid(random(width),random(height)));
    ffloids.add(new Firefloid(random(width),random(height)));
  }
  //recordStart(3600,"Exports/RiseAndRebirth.mp4",30);
}

void draw(){
  //background(0);
  PImage canvas = get();
  tint(200,200,200,230);
  //filter(BLUR);
  image(canvas,0,0);
  
  for (int i = 0; i < 2; i ++){
  ffloids.add(new Firefloid(random(width),random(height)));
  }
  
  qTree = new Quadtree(40);
  //qTree.insert(boids);
  qTree.insert(ffloids);
  
  /*
  for (Boid b : boids){
    b.update(qTree);
    b.show(#ffffff,#ffffff,3);
  }*/
  /*
  for (Firefloid f : ffloids){
    f.update(qTree,"DUMB");
    f.show(#555555,#222222,#ffdd00,7);
  }*/
  //sys = new VoronoiSystem(boids);
  sys = new VoronoiSystem(ffloids);
  sys.generate();
  //sys.show();
  /*
  PGraphics pg = createGraphics(width,height);
  PGraphics mask = createGraphics(width,height);
  pg.beginDraw();
  mask.beginDraw();
  mask.background(0);*/
  for (Firefloid f : ffloids){
    VCell cell = null;
    for (VCell v : sys.cells){
      if (v.site == f.ref){
        cell = v;
        break;
      }
    }
    Polygon polygon = cell.clipped();
    //f.update(qTree,"yay");
    f.update(qTree);
    //polygon.crop(2);
    //polygon.scale(0.9);
    polygon.chaikinCurve(0.15,3,30);
    
    //float effectiveLightTime = f.cooldown-(cooldownTime-lightTime)+30;
    //color col = lerpColor(#222222,#ffffff, max(0,effectiveLightTime/(float)lightTime) );
    
    //color col = #ffffff;
    
    ArrayList<Firefloid> neighbours = f.findNeighbours(qTree, viewRange, viewAngle);
    /*
    color col = lerpColor(color(22,22,128,8),color(99,255,230,128), pow(0.1*(neighbours.size()),1.5) );
    if (neighbours.size() > 10) col = lerpColor(color(99,255,230,128),#ffffff, pow(0.2*(neighbours.size()-10),0.7) );*/
    
    colorMode(RGB);
    color col = lerpColor(color(22,22,22,8),color(150,150,150,128), pow(0.1*(neighbours.size()),1.5) );
    if (neighbours.size() > 10) col = lerpColor(color(150,150,150,128),#ffffff, pow(0.2*(neighbours.size()-10),0.7) );
    colorMode(HSB);
    polygon.show(color( (frameCount+noise(f.x*0.01,f.y*0.01)*200)%256 , (noise(f.y*0.05,f.x*0.05)*256f) , brightness(col) , alpha(col)),#ffffff,0);
    colorMode(RGB);
    
    //polygon.show(#ffffff,#ffffff,0,true,mask);
    //f.show(color(0,0,0,64),color(0,0,0,64),#ffdd00,4);
    //mask.fill(0,0,0); mask.noStroke();
    //mask.circle(f.x,f.y,7);
  }
  /*
  pg.endDraw();
  mask.endDraw();
  //pg.mask(mask);
  noTint();
  image(pg,0,0);*/
  
  ///float value = abs(sin(frameCount*0.1) + sin(frameCount*0.1+10))/2;
  //value = min(amp.analyze()*5,1);
  //circleSize = max(width/3, min(width/8, circleSize + randomGaussian()*15));
  
  
  diagnostics();
  //recordUpdate();
}
