/*
void quickSort(int[] array, int start, int end){
  if (start < end){
    int i = partition(array, start, end);
    quickSort(array, start, i-1);
    quickSort(array, i+1, end);
  }
}

int partition(int[] array, int start, int end){
  
  int pivot = array[end];
  int i = start-1;
  
  for (int j = start; j < end; j++){
    if (array[j] <= pivot){
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
*/
