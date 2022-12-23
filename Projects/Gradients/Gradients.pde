//Gradient gradient = new Gradient(0,0.33,0.67);
Gradient[] gradients;
Ball b;
float d0 = 0;
float d1 = 0.33;


void setup(){
  size(1000,1000);
  gradients = new Gradient[height];
  /*
  loadPixels();
  for(int x = 0; x < width; x++){
    color c = unhex(gradient.evaluate((float)x/width));
    for (int y = 0; y < height; y++){
      pixels[y*width+x] = c;
    }
  }
  updatePixels();*/
  
  b = new Ball(random(width), random(height));
  
  recordStart(1800,"Exports/Glowy.mp4");
}

void draw(){
  
  //d0 = (float)mouseX/width;
  //d1 = (float)mouseY/height;
  
  b.update();
  d0 = (float)b.x/width;
  d1 = (float)b.y/height;
  
  loadPixels();
  for (int y = 0; y < height; y++){
    gradients[y] = new Gradient(d0,d1,(float)y/height);
    Gradient gradient = gradients[y];
    for(int x = 0; x < width; x++){
      color c = unhex(gradient.evaluate((float)x/width));
      pixels[y*width+x] = c;
    }
  }
  updatePixels();
  
  //b.show();
  
  print(frameRate+"\n");
  recordUpdate();
}
