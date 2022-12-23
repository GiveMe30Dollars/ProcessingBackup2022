class TruchetTile{
  float x;
  float y;
  float s;
  int depth;
  boolean divided;
  TruchetTile[] children;
  PGraphics baseTile;
  //int value;
  
  TruchetTile(float x_, float y_, float s_, int depth_){
    x = x_;
    y = y_;
    s = s_;
    depth = depth_;
    //value = value_;
    divided = false;
    children = null;
  }
  
  void drawTile(int mainColorValue, int secondaryColorValue){
    
    if(divided){
      return;
    }
    
    color mainColor = color(mainColorValue);
    color secondaryColor = color(secondaryColorValue);
    
    noStroke();
    PGraphics baseTile = createGraphics((int)s,(int)s,P2D);
    
    baseTile.beginDraw();
    
    baseTile.background(mainColor);
    
    baseTile.fill(secondaryColor);
    int randomValue = floor(random(4));
    
    switch (randomValue){
      case 0:
        baseTile.circle(0, 0, s*4f/3f);
        baseTile.circle(s, s, s*4f/3f);
        break;
      case 1:
        baseTile.circle(s, 0, s*4f/3f);
        baseTile.circle(0, s, s*4f/3f);
        break;
      case 2:
        baseTile.rect(0,s/3f,s,s/3f);
        break;
      case 3:
        baseTile.rect(s/3f,0,s/3f,s);
        break;
    }
    
    baseTile.endDraw();
    
    image(baseTile, x, y);
    
    fill(secondaryColor);
    circle(x, y+s/2f, s/3f -wingMargin);
    circle(x+s, y+s/2f, s/3f -wingMargin);
    circle(x+s/2f, y, s/3f -wingMargin);
    circle(x+s/2f, y+s, s/3f -wingMargin);
    
    fill(mainColor);
    circle(x, y, s*2f/3f -1);
    circle(x, y+s, s*2f/3f -1);
    circle(x+s, y, s*2f/3f -1);
    circle(x+s, y+s, s*2f/3f -1);
  }
  
  void onClick(float x_, float y_){
    if (divided){
      for(TruchetTile tile: children){
        tile.onClick(x_,y_);
      }
      return;
    }
    if (containsPoint(x_,y_) && !divided){
      children = new TruchetTile[4];
      children[0] = new TruchetTile(x, y, s/2, depth+1);
      children[1] = new TruchetTile(x, y+s/2, s/2, depth+1);
      children[2] = new TruchetTile(x+s/2, y, s/2, depth+1);
      children[3] = new TruchetTile(x+s/2, y+s/2, s/2, depth+1);
      divided = true;
    }
  }
  
  
  int getTotalDepth(){
    if (!divided) return depth;
    else {
      return max(max(children[0].getTotalDepth(), children[1].getTotalDepth()),
                 max(children[2].getTotalDepth(), children[3].getTotalDepth()));
    }
  }
  
  void getTileOfDepth(int d, ArrayList<TruchetTile> tiles){
    if (d == depth){
      tiles.add(this);
      return;
    }
    else if (d < depth) return;
    else if (divided){
      for (TruchetTile child : children){
        child.getTileOfDepth(d, tiles);
      }
      return;
    }
  }
  
  void show(int mainColorValue, int secondaryColorValue){
    int totalDepth = this.getTotalDepth();
    ArrayList<TruchetTile>[] tiles = new ArrayList[totalDepth+1];
    
    for (int i = 0; i <= totalDepth; i++){
      tiles[i] = new ArrayList<TruchetTile>();
      this.getTileOfDepth(i,tiles[i]);
    }
    
    for (int i = 0; i <= totalDepth; i++){
      int mainC, secondC;
      
      if (i%2 == 0){
        mainC = mainColorValue;
        secondC = secondaryColorValue;
      }
      else{
        mainC = secondaryColorValue;
        secondC = mainColorValue;
      }
      
      for (TruchetTile tile : tiles[i]){
        tile.drawTile(mainC, secondC);
      }
    }
  }
  
  boolean containsPoint(float x_, float y_){
    return !(x_ < x || x_ > x+s || y_ < y || y_ > y+s);
  }
  
}
