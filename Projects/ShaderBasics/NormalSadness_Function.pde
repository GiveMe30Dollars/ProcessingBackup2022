void theNormal(){
  loadPixels();
  for (int y = 0; y < height; y++){
    for (int x = 0; x < width; x++){
      PVector displacement = new PVector((float)x/width-lightPos.x/width, (float)y/height-lightPos.y/height);
      float mag = displacement.mag();
      float illumination = min(reach/mag,1);
      pixels[y*width+x] = color(illumination*256,illumination*256,illumination*256,255);
    }
  }
  updatePixels();
}
