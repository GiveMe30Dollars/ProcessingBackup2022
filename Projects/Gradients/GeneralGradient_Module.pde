class Gradient{
  float[] a = new float[]{0.5, 0.5, 0.5};
  float[] b = new float[]{0.5, 0.5, 0.5};
  float[] c = new float[]{1.0, 1.0, 1.0};
  float[] d = new float[]{0.0, 0.33, 0.67};
  Gradient(float d0, float d1, float d2){
    d = new float[]{d0, d1, d2};
  }
  Gradient(float c0, float c1, float c2, float d0, float d1, float d2){
    c = new float[]{c0, c1, c2};
    d = new float[]{d0, d1, d2};
  }
  
  String evaluate(float t){
    float[] col = new float[3];
    for (int i = 0; i < 3; i++){
      col[i] = a[i] + b[i] * cos(TWO_PI*(c[i]*t+d[i]));
    }
    color parse = color(col[0]*256, col[1]*256, col[2]*256);
    return hex(parse);
  }
}
