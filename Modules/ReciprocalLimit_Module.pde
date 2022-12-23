float reciprocalLimit(float x, float m, float s){
  return m - m/(s*x+1);
}

float reciprocalLimit(float x, float m){
  return reciprocalLimit(x,m,2);
}
