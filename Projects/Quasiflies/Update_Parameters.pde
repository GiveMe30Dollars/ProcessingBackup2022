int variableType = 0;
String variableName = "multiplier_A";
float variableValue = 0f;
boolean showVariable = false;
boolean pressed = false;

void displayParameters(){
  if (!showVariable) return;
  fill(255);
  String displayMessage = variableName + " = " + variableValue;
  text(displayMessage, 10, 20);
}

void keyReleased(){
  pressed = false;
}

void updateParameters(){
  
  if (pressed) return;
  pressed = true;
  
  if (keyCode==UP){
    switch (variableType){
      case 0:
        multiplier_A += 0.01; 
        variableName = "multiplier_A";
        variableValue = multiplier_A;
        break;
      case 1:
        multiplier_C += 0.01; 
        variableName = "multiplier_C";
        variableValue = multiplier_C;
        break;
      case 2:
        multiplier_S += 0.01; 
        variableName = "multiplier_S";
        variableValue = multiplier_S;
        break;
      case 3:
        multiplier_O += 0.01; 
        variableName = "multiplier_O";
        variableValue = multiplier_O;
        break;
      case 4:
        damping += 0.01; 
        variableName = "damping";
        variableValue = damping;
        break;
      case 5:
        size += 0.5; 
        variableName = "size";
        variableValue = size;
        break;
      case 6:
        viewRange += 5; 
        variableName = "viewRange";
        variableValue = viewRange;
        break;
      case 7:
        viewAngle += 5; 
        variableName = "viewAngle";
        variableValue = viewAngle;
        break;
    }
  }
  if (keyCode==DOWN){
    switch (variableType){
      case 0:
        multiplier_A -= 0.1; 
        variableName = "multiplier_A";
        variableValue = multiplier_A;
        break;
      case 1:
        multiplier_C -= 0.1; 
        variableName = "multiplier_C";
        variableValue = multiplier_C;
        break;
      case 2:
        multiplier_S -= 0.1; 
        variableName = "multiplier_S";
        variableValue = multiplier_S;
        break;
      case 3:
        multiplier_O -= 0.01; 
        variableName = "multiplier_O";
        variableValue = multiplier_O;
        break;
      case 4:
        damping -= 0.01; 
        variableName = "damping";
        variableValue = damping;
        break;
      case 5:
        size -= 0.5; 
        variableName = "size";
        variableValue = size;
        break;
      case 6:
        viewRange -= 5; 
        variableName = "viewRange";
        variableValue = viewRange;
        break;
      case 7:
        viewAngle -= 5; 
        variableName = "viewAngle";
        variableValue = viewAngle;
        break;
    }
  }
  
  if (keyCode==LEFT || keyCode==RIGHT){
    
    if (keyCode==LEFT) variableType--;
    if (keyCode==RIGHT) variableType++;
    
    switch (variableType){
      case 0:
        variableName = "multiplier_A";
        variableValue = multiplier_A;
        break;
      case 1:
        variableName = "multiplier_C";
        variableValue = multiplier_C;
        break;
      case 2:
        variableName = "multiplier_S";
        variableValue = multiplier_S;
        break;
      case 3:
        variableName = "multiplier_O";
        variableValue = multiplier_O;
        break;
      case 4:
        variableName = "damping";
        variableValue = damping;
        break;
      case 5:
        variableName = "size";
        variableValue = size;
        break;
      case 6:
        variableName = "viewRange";
        variableValue = viewRange;
        break;
      case 7:
        variableName = "viewAngle";
        variableValue = viewAngle;
        break;
    }
  }
  
  if (keyCode==SHIFT) showVariable = !showVariable;
  if (key==ENTER || key==RETURN) generateBoids();
}
