float colorDstSqr(color c){
  float r = red(c);
  float g = green(c);
  float b = blue(c);
  return r*r + g*g + b*b;
}

color difference(color c1, color c2){
  return color(abs( red(c1)-red(c2) ),
               abs( green(c1)-green(c2) ),
               abs( blue(c1)-blue(c2) ));
}

int indexOfClosestColor(color c, color[] clusters){  // returns the color in array that closest matchs the imput
  int indexOfClosestColor = 0;
  float lowestWeight = Float.POSITIVE_INFINITY;
  for(int j = 0; j < clusters.length; j++){
    color diff = difference(c, clusters[j]);
    float weight = colorDstSqr(diff);
    if (weight < lowestWeight){
      lowestWeight = weight;
      indexOfClosestColor = j;
    }
  }
  return indexOfClosestColor;
}



color [] randomColors(PImage img, int k){
  color[] colors = new color[k];
  for (int j = 0; j < k; j++){  // select random colors in picture as starting cluster
    colors[j] = img.pixels[(int)random(img.pixels.length)];
  }
  return colors;
}



color[] kMeansClusteringIterative(PImage img, color[] clusters, PImage output){
  
  color[] newClusters = new color[clusters.length];
  float[][] clusterValues = new float[clusters.length][4]; // store cluster average value; 0: red, 1: blue, 2: green, 3: amount
  
  for(int i = 0; i < img.pixels.length; i++){
    int indexOfClosestCluster = indexOfClosestColor(img.pixels[i], clusters);
    if (output != null) output.pixels[i] = clusters[indexOfClosestCluster];
    
    clusterValues[indexOfClosestCluster][0] += red(img.pixels[i]);
    clusterValues[indexOfClosestCluster][1] += green(img.pixels[i]);
    clusterValues[indexOfClosestCluster][2] += blue(img.pixels[i]);
    clusterValues[indexOfClosestCluster][3] ++;
  }
  
  for (int j = 0; j < newClusters.length; j++){
    float[] values = clusterValues[j];
    color c = color(values[0]/values[3], values[1]/values[3], values[2]/values[3]);
    newClusters[j] = c;
  }
  
  return newClusters;
}
