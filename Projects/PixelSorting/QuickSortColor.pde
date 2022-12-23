void quickSort(color[] array, String sortType){
  quickSort(array, 0, array.length-1, sortType);
}

/*
//Recursive Version
void quickSort(color[] array, int start, int end, String sortType){
  if (start < end){
    int i = partition(array, start, end, sortType);
    quickSort(array, start, i-1, sortType);
    quickSort(array, i+1, end, sortType);
  }
}
*/


// Iterative Version
void quickSort(color array[], int start, int end, String sortType)
{
  if(start < end){
    int[] stack = new int[end - start + 1];
  
    int top = -1;
  
    stack[++top] = start;
    stack[++top] = end;
  
    while (top >= 0) {

      end = stack[top--];
      start = stack[top--];

      int p = partition(array, start, end, sortType);

      if (p - 1 > start) {
        stack[++top] = start;
        stack[++top] = p - 1;
      }

        if (p + 1 < end) {
        stack[++top] = p + 1;
        stack[++top] = end;
      }
    }
  }
}


int partition(color[] array, int start, int end, String sortType){
  
  int pivot = sortValue(array[end], sortType);
  int i = start-1;
  
  for (int j = start; j < end; j++){
    if (sortValue(array[j], sortType) <= pivot){
      i++;
      int temp = array[j];
      array[j] = array[i];
      array[i] = temp;
    }
  }
  
  int swapTemp = array[i+1];
  array[i+1] = array[end];
  array[end] = swapTemp;
  
  return (i+1);
}

int sortValue(color value, String sortType){
  switch (sortType){
    case "R":
      return (int)red(value);
    case "G":
      return (int)green(value);
    case "B":
      return (int)blue(value);
    case "H":
      return (int)hue(value);
    case "S":
      return (int)saturation(value);
    case "V":
      return (int)brightness(value);
  }
  return -1;
}
