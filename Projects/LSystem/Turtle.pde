import java.util.*;

class Transform{
  float x,y;
  Object ref;
  Transform(float x_, float y_){
    x = x_;
    y = y_;
  }
}

class TurtleState extends Transform{
  float r;
  TurtleState(float x_, float y_, float r_){
    super(x_,y_);
    r = r_;
  }
  
  TurtleState state(){
    return new TurtleState(x,y,r);
  }
}

class Turtle extends TurtleState{
  float moveMagnitude = 20;
  float rotationMagnitude = HALF_PI;
  boolean penDown = true;
  Stack<TurtleState> stack;
  Turtle(float x_, float y_, float r_){
    super(x_,y_,r_);
    stack = new Stack<TurtleState>();
  }
  
  void execute(String instr){
    execute(instr, moveMagnitude, rotationMagnitude);
  }  
  void execute(String instr, float moveMag, float rotMag){
    char[] characters = instr.toCharArray();
    for (char c : characters){
      //print(c);
      switch(c){
        case 'F': moveForward(moveMag); break;
        case '+': turnLeft(rotMag); break;
        case '-': turnRight(rotMag); break;
        case '[': stack.push(super.state()); break;
        case ']': restore(stack.pop()); break;
        default: break;
      }
    }
  }
  
  void moveForward(float mag){
    float newX = x + mag * cos(r);
    float newY = y + mag * sin(r);
    line(x,y,newX,newY);
    x = newX; y = newY;
  }
  void turnLeft(float theta){ 
    r += theta; 
  }
  void turnRight(float theta){
    r -= theta;
  }
  void restore(TurtleState state){
    x = state.x;
    y = state.y;
    r = state.r;
  }
}
