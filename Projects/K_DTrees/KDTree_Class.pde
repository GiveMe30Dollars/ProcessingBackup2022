class KDTree{
  int sortVal;
  KDTree before = null;
  KDTree after = null;
  Transform pivot = null;
  Rectangle box;
  
  KDTree(ArrayList<Transform> points, int sortVal_, Rectangle box_){
    sortVal = sortVal_;
    box = box_;
    
    partition(points);
  }
  KDTree(ArrayList<Transform> points){
    sortVal = -1;
    box = new Rectangle(0,0,width,height);
    partition(points);
  }
  
  void partition(ArrayList<Transform> points){
    if (points.size() <= 0){
      sortVal = 0;
      return;
    }
    if (points.size() == 1){
      pivot = points.get(0);
      return;
    }
    
    switch (sortVal){
      case -1:
        Collections.sort(points, new SortByX());
        break;
      case 1:
        Collections.sort(points, new SortByY());
        break;
      default:
        break;
    }
    
    int median = floor(points.size()/2);
    pivot = points.get(median);
    ArrayList<Transform> beforePoints = new ArrayList<Transform>(points.subList(0,max(median-1,0)));
    ArrayList<Transform> afterPoints = new ArrayList<Transform>(points.subList(min(median+1,points.size()-1),points.size()-1));
    
    Rectangle beforeBox; Rectangle afterBox;
    switch (sortVal){
      case -1:
        beforeBox = new Rectangle(box.x, box.y, pivot.x-box.x, box.h);
        afterBox = new Rectangle(pivot.x, box.y, box.x+box.w-pivot.x, box.h);
        break;
      case 1:
        beforeBox = new Rectangle(box.x, box.y, box.w, pivot.y-box.y);
        afterBox = new Rectangle(box.x, pivot.y, box.w, box.y+box.h-pivot.y);
        break;
      default:
        beforeBox = null;
        afterBox = null;
        break;
    }
    
    before = new KDTree( beforePoints , sortVal*-1 , beforeBox);
    after = new KDTree( afterPoints , sortVal*-1 , afterBox);
  }
  
  void show(color horizontal, color vertical, float weight){
    Line l;
    switch (sortVal){
      case -1:
        l = new Segment(pivot.x, box.y, pivot.x, box.y+box.h);
        l.show(horizontal,weight);
        break;
      case 1:
        l = new Segment(box.x, pivot.y, box.x+box.w, pivot.y);
        l.show(vertical,weight);
        break;
      default:
        break;
    }
    if (pivot != null){
      fill(#ffffff); noStroke();
      circle(pivot.x,pivot.y,5);
    }
    
    if (before != null) before.show(horizontal,vertical,weight);
    if (after != null) after.show(horizontal,vertical,weight);
  }
}
