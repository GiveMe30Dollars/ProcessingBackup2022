
uniform int n;
uniform float[30] posX;
uniform float[30] posY;
uniform float reach;
uniform vec2 resolution;


float smin( float a, float b, float k )
{
    a = pow( a, k ); b = pow( b, k );
    return pow( (a*b)/(a+b), 1.0/k );
}
float smin(float a, float b){
  return smin(a,b,1.5);
}



void main(){
  vec2 displacement = gl_FragCoord.xy/resolution - vec2(posX[0],posY[0])/resolution;
  float mag = length(displacement);
  for (int i = 1; i < n; i++){
    vec2 displacement = gl_FragCoord.xy/resolution - vec2(posX[i],posY[i])/resolution;
	mag = smin(length(displacement),mag);
  }
  float illumination = clamp(reach/mag,0.0,1.0);
  gl_FragColor = vec4(vec3(illumination),1);
}