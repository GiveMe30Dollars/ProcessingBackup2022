PImage src;
PImage img1;
PImage img2;

void setup(){
  //fullScreen();
  //size(1200,800);
  size(800,800);
  
  PImage src = loadImage("Daisy.jpg");
  src.resize(width/2,height/2);
  PImage src1 = gaussianBlur(src, 2, 1.4);
  img1 = sobelOperator(src1);
  img2 = cannyEdgeDetector(src1, 0.1, 0.3); 
  
  PImage img3 = sobelOperatorColor(src1);
  
  //img1.resize(500,500);
  //img2.resize(500,500);
  
  image(src,0,0);
  image(img3,width/2,0);
  image(img1,0,height/2);
  image(img2,width/2,height/2);
  
  //image(img3,0,0);
  //image(img2,500,0);
  //save("DaisyEdited.png");
}

void draw(){
  
}
