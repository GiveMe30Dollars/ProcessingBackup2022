void navigate3D(){
  /*
  if (keyPressed){
    if (keyCode == UP && xRotation > 0) xRotation -= 0.05;
    if (keyCode == DOWN && xRotation < PI/2) xRotation += 0.05;
    if (keyCode == LEFT) zRotation -= 0.05;
    if (keyCode == RIGHT) zRotation += 0.05;
  }*/
  
  if (keyPressed){
    if (keyCode == UP && xRotation > 0) xVel -= 0.07;
    if (keyCode == DOWN && xRotation < HALF_PI) xVel += 0.07;
    if (keyCode == LEFT) zVel -= 0.07;
    if (keyCode == RIGHT) zVel += 0.07;
    if (keyCode == ENTER) setup();
    if (key == 'r') recordStart("C:/Users/willi/Pictures/Erosion/FlowingIce", -1);
    if (key == 'e') recordEnd();
  }
  xRotation += xVel;
  xRotation = clamp(0, xRotation, HALF_PI);
  zRotation += zVel;
  xVel *= 0.5;
  zVel *= 0.5;
  
}
