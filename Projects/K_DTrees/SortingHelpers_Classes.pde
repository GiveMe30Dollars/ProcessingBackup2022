import java.util.*;

class SortByX implements Comparator<Transform>{
  public int compare(Transform a, Transform b){
    return ceil(a.x - b.x);
  }
}

class SortByY implements Comparator<Transform>{
  public int compare(Transform a, Transform b){
    return ceil(a.y - b.y);
  }
}
