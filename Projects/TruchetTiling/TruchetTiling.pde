TruchetTile tile;
color black;
color white;
float wingMargin = 2;

void setup(){
  size(1000,1000,P2D);
  tile = new TruchetTile(0f,0f,width, 0);
  //tile = new TruchetTile(333f,333f,333f);
  //color black = #000000;
  //color white = #FFFFFF;
  background(150);
  for (int i = 0; i < 50; i++){
    tile.onClick(random(width), random(height));
  }
  tile.show(0, 255);
}

void draw(){
  //tile.show(0,255);
}

void mouseClicked(){
  background(150);
  tile.onClick(mouseX,mouseY);
  tile.show(0, 255);
}
