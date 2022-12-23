int pointPerLine = 150;
int lineNumber = 100;
color c = color(255,64,32,64);
float offset = 1;
float posSD = 15;
float colorSD = 5;

void setup(){
  size(1000,1000);
  background(0);
  sandLine(50,250,950,750,c, pointPerLine, lineNumber, offset, posSD, colorSD);
}
