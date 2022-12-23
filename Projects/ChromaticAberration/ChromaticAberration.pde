PImage aberrate(PImage src, float d){
  PImage output = createImage(src.width,src.height,RGB);
  src.loadPixels();
  output.loadPixels();
  for (int y = 0; y < src.height; y++){
    for (int x = 0; x < src.width; x++){
      float valRed = getValue(src, x-floor(d), y-floor(d/2));
      float valGreen = getValue(src, x+floor(d), y-floor(d/2));
      float valBlue = getValue(src, x, y+floor(d/2));
      output.pixels[y*src.width+x] = color(valRed, valGreen, valBlue);
    }
  }
  output.updatePixels();
  return output;
}

float getValue(PImage src, int x, int y){
  return getValue(src,x,y,brightness(src.pixels[0]));
}
float getValue(PImage src, int x, int y, float defaultVal){
  if (x < 0 || x >= src.width || y < 0 || y >= src.height) return defaultVal;
  else return brightness(src.pixels[y*src.width+x]);
}

PImage src;
PImage output;
int n = 1;


void setup(){
  size(1000,1000);
  src = loadImage("data/VCells.png");
  src.filter(INVERT);
  //recordStart(450,"Exports/Glitching.mp4",15);
}


void draw(){
  output = aberrate(src,n);
  scale(0.5);
  image(output,0,0);
  //n+=3;
  //n = floor(randomGaussian()*25);
  
  //recordUpdate();
}

void keyPressed(){
  n = floor(randomGaussian()*75);
}

void mouseClicked(){
  output.save("Exports/Voronoid.png");
  print("Exported.");
}
