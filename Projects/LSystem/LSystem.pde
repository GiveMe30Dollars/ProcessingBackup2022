Turtle turtle;
int num = 1;
float size = 150;
String instr;

void setup(){
  size(1000,1000);
  //background(0);
  /*
  turtle = new Turtle(width/2, height, 0);
  turtle.r = -HALF_PI;
  turtle.rotationMagnitude = 25 * TWO_PI / 180;
  turtle.moveMagnitude = size;
  */
  HashMap<String,String> map = new HashMap<String,String>();
  map.put("X", "F+[[X]-X]-F[-FX]+X");
  map.put("F", "FF");
  instr = mutate("X", map, num);
  //print(instr+"\n");
  /*
  stroke(255,255,255,128);
  strokeWeight(1.5);
  turtle.execute(instr);*/
}

void draw(){
  background(0);
  
  turtle = new Turtle(width/2, height, 0);
  turtle.r = -HALF_PI;
  turtle.rotationMagnitude = (20+2*sin(millis()*0.001)) * TWO_PI / 180;
  turtle.moveMagnitude = size;
  /*
  HashMap<String,String> map = new HashMap<String,String>();
  map.put("X", "F+[[X]-X]-F[-FX]+X");
  map.put("F", "FF");
  String instr = mutate("X", map, num);*/
  //print(instr+"\n");
  
  stroke(255,255,255);
  strokeWeight(0.5);
  turtle.execute(instr);
}

void mouseClicked(){
  num += 1;
  size /= 2;
  setup();
}
