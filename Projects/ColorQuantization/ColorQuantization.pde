float threshold = 100;
PImage image;
PImage output;
color[] clusters;
Superpixel[] superpixels;
int frameLimit = 150;

float m = 25;

void setup(){
  size(1600,900);
  image = loadImage("Pics/Hitchhiker.jpg");
  /*
  //Grayscale Threshold Demo
  clusters = new color[8];
  for (int j = 0; j < clusters.length; j++){
    //clusters[j] = color((float)j/(clusters.length-1)*255);
    clusters[j] = color(random(255), random(255), 0);
  }*/
  
  /*
  //Color Threshold Demo
  int steps = 8;
  clusters = new color[(int)pow(steps,3)];
  int i = 0;
  for (int b = 0; b < steps; b++){
    for (int g = 0; g < steps; g++){
      for (int r = 0; r < steps; r++){
        clusters[i] = color((float)r/(steps-1)*255,
                                 (float)g/(steps-1)*255,
                                 (float)b/(steps-1)*255);
        print(hex(clusters[i])+"\n");
        i++;
      }
    }
  }
  print(i+" "+clusters.length);
  */
  
  
  // K-Means Clustering Demo
  clusters = randomColors(image,24);
  // Superpixels Demo
  superpixels = randomSuperpixels(image,90);
  
}
 
void draw(){
  
  output = image.copy();
  output.loadPixels();
  
  //clusters = kMeansClusteringIterative(image,clusters,output);
  superpixels = SLICIterative(image,superpixels,m,output);
  
  output.updatePixels();
  image(output,0,0);
  /*
  image.loadPixels();
  for(int i = 0; i < image.pixels.length; i++){
    color pix = image.pixels[i];
    
  }
  image.updatePixels();
  */
  print(frameRate+"  "+frameCount+"\n");
  saveFrame("Valley/frame_####.png");
  if (frameCount >= frameLimit) noLoop();
}

void mouseClicked(){
  //save("Undergrowth5Tone.png");
}
