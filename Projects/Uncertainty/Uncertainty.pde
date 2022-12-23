ArrayList<Quark> sys;
float circleSize = 450;

void setup(){
  size(1000,1000);
  background(0);
  sys = new ArrayList<Quark>();
  colorMode(HSB);
  for (int i = 0; i < 100; i++){
    color stillCol = color(255,0,255,150);
    color speedCol = color(160+random(80),255,200,100);
    //color speedCol = color(255,0,200,100);
    sys.add(new Quark(random(width), random(height), stillCol, speedCol));
  }
  colorMode(RGB);
  
  //recordStart(450,"Exports/Painbow.mp4",30);
}

int margin = 0;

void draw(){
  PImage canvas = get();
  tint(200,200,200,100);
  //canvas = aberrate(canvas,20);
  canvas.resize(width+2*margin, height+2*margin);
  image(canvas,-margin,-margin);
  //blendMode(ADD);
  for (Quark q : sys){
    q.update();
    q.show(10,5);
  }
  //blendMode(BLEND);
  
  circleSize = 300+50*sin(frameCount*0.01);
  
  diagnostics();
  //recordUpdate();
}
