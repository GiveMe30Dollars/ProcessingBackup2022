float reciprocalLimit(float x, float m, float s){
  return m - m/(s*x+1);
}

float reciprocalLimit(float x, float m){
  return reciprocalLimit(x,m,2);
}

float reciprocalLimit(float x){
  return reciprocalLimit(x,1,2);
}
