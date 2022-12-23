String mutate(String seed, HashMap<String, String> map){
  StringBuffer output = new StringBuffer();
  int pointer = 0;
  
  while (pointer < seed.length()){
    boolean match = false;
    for (String k : map.keySet()){
      String substring = seed.substring(pointer, pointer + k.length());
      if (k.equals(substring)){
        output.append(map.get(k));
        pointer += k.length();
        match = true;
        break;
      }
    }
    if (!match){
      output.append(seed.charAt(pointer));
      pointer += 1;
    }
  }
  
  return output.toString();
}

String mutate(String seed, HashMap<String,String> map, int num){
  String buffer = seed;
  for (int i = 0; i < num; i++){
    buffer = mutate(buffer, map);
  }
  return buffer;
}
