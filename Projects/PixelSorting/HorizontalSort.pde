void horizontalSort(PImage image, String sortType){
  for (int i = 0; i < image.pixels.length; i += image.width){
    quickSort(image.pixels, i, i + image.width - 1, sortType);
  }
}
