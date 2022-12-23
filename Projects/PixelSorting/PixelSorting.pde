void setup(){
  
  // BASE QUICKSORT TEST
  /*
  int[] array = {65,12,74,65,92,64,35,6,1,95,75};
  quickSort(array, 0, array.length-1);
  for (int i : array){
    print(i+" ");
  }
  */
  
  
  
  String name = "Beach";
  String fileFormat = ".jpg";
  
  PImage img = loadImage(name + fileFormat);
  
  img.loadPixels();
  PImage sorted = img.get();
  sorted.loadPixels();
  
  String sortType = "V";
  String sortMode = "ThresholdSort";
  
  switch(sortMode){
    case "QuickSort":
      quickSort(sorted.pixels, sortType);
      break;
    case "HorizontalSort":
      horizontalSort(sorted, sortType);
      break;
    case "ThresholdSort":
      thresholdSort(sorted, sortType, "V", 100, 200);
      break;
  }
  
  sorted.updatePixels();
  
  //size(1000,600);  // beach3 Side-by-side
  size(500,600);  // beach3 Solo
  
  //size(1000,1000);
  
  image(sorted, 0, 0);
  //image(img, 0, 0);
  //image(sorted, img.width, 0);
  
  save(name + "_" + sortMode + "_" + sortType + fileFormat);
}
