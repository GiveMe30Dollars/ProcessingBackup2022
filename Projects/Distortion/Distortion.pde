//Walker w;

void setup(){
  size(500,500);
  background(0);
  noStroke();
  //w = new Walker(width/2, height/2);
  /*
  for (int y = 0; y < height; y++){
    for (int x = 0; x < width; x++){
      if (random(1) > 0.5) circle(x,y,2);
    }
  }*/
  recordStart(1800,"Flowing.mp4",30);
}

void draw(){
  
  PImage canvas = get();
  tint(230,230,230,15);
  image(canvas,0,0);
  distort(0.01,3);
  
  if (frameCount%2 == 0){
    circle(random(width),random(height),random(100));
  }
  //w.update();
  //w.show(#ffffff);
  
  diagnostics();
  recordUpdate();
}

void distort(float scale, float displacement){
  PImage canvas = get();
  PImage output = createImage(width,height,RGB);
  canvas.loadPixels();
  output.loadPixels();
  for (int y = 0; y < height; y++){
    for (int x = 0; x < width; x++){
      int i = y*width+x;
      PVector offset = new PVector(noise(x*scale,y*scale)*2-1, noise(y*scale+2000,x*scale)*2-1).normalize().mult(displacement);
      //PVector offset = new PVector(5,0).rotate(noise(x*scale,y*scale)*TWO_PI).mult(displacement);
      color col = getValue(canvas, x+offset.x, y+offset.y, canvas.pixels[i]);
      output.pixels[i] = col;
    }
  }
  output.updatePixels();
  image(output,0,0);
}

void mouseClicked(){
  circle(mouseX,mouseY,30);
}


color getValue(PImage src, float x, float y){
  return getValue(src,x,y,src.pixels[0]);
}
color getValue(PImage src, float x, float y, color defaultVal){
  if (x < 0 || x >= src.width-1 || y < 0 || y >= src.height-1) return defaultVal;
  else {
    float percentX = x - floor(x);
    float percentY = y - floor(y);
    color topLeft = src.pixels[floor(y)*src.width+floor(x)];
    color topRight = src.pixels[floor(y)*src.width+floor(x)+1];
    color bottomLeft = src.pixels[floor(y)*src.width+src.width+floor(x)];
    color bottomRight = src.pixels[floor(y)*src.width+src.width+floor(x)+1];
    color top = lerpColor(topLeft,topRight,percentX);
    color bottom = lerpColor(bottomLeft,bottomRight,percentX);
    return lerpColor(top,bottom,percentY);
  }
}
