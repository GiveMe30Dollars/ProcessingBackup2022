void thresholdSort(PImage image, String sortType, String thresholdType, int low, int high){
  for (int r = 0; r < image.pixels.length; r += image.width){
    int i = r;
    for (int j = r; j < r + image.width; j++){
      if (sortValue(image.pixels[j], thresholdType) < low || sortValue(image.pixels[j], thresholdType) > high){
        quickSort(image.pixels, i, j-1, sortType);
        i = j + 1;
      }
      else if (j == r + image.width - 1){
        quickSort(image.pixels, i, j, sortType);
      }
    }
  }
}
