ArrayList<Transform> points;
float spawnMargin = 100;
KDTree kdtree;

void setup(){
  size(1000,1000);
  background(0);
  points = new ArrayList<Transform>();
  for (int i = 0; i < 30; i++){
    points.add(new Transform( random(width-2*spawnMargin)+spawnMargin , random(width-2*spawnMargin)+spawnMargin) );
  }
  kdtree = new KDTree(points);
}

void draw(){
  for (Transform t : points){
    fill(#ff0000); noStroke();
    circle(t.x,t.y,5);
  }
  
  kdtree.show(#998800,#008899,2.5);
}
