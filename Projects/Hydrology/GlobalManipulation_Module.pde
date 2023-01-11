

void multAll(float[][] map, float c){
  for (int y = 0; y < map.length; y++){
    for (int x = 0; x < map[0].length; x++){
      map[x][y] *= c;
    }
  }
}
