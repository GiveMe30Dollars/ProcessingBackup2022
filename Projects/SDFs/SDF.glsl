#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform vec2 circlePos;
uniform float radius;
uniform float dropoffAmnt;
uniform float stepAmnt;

float sdCircle(in vec2 p, in float r){
  return length(p)-r;
}

float smin(float a, float b, float k){
  float h = clamp( 0.5+0.5*(b-a)/k, 0.0, 1.0 );
  return mix( b, a, h ) - k*h*(1.0-h);
}
float smin(float a, float b){
  return smin(a,b,0.1);
}

vec3 black = vec3(0);
vec3 white = vec3(1);
vec3 gray = vec3(0.25);
vec3 cyan = vec3(0.7,1,1);
vec3 orange = vec3(1,0.6,0);

void main(){
  vec2 displacement = gl_FragCoord.xy/resolution - circlePos/resolution;
  float sdVal = sdCircle(displacement,radius);
  float dstVal = abs(sdVal)*dropoffAmnt;
  vec3 color = sdVal > 0 ? orange : cyan;
  vec3 dstCol = mix(black, color, smoothstep(0,1,clamp(dstVal,0,1)));
  
  float stepVal = sdVal*stepAmnt;
  float stepDiff = min(fract(stepVal), 1-fract(stepVal));
  vec3 thresholdCol = mix(black,gray,clamp(dstVal*0.25,0,1));
  vec3 stepCol = mix(thresholdCol,dstCol,sqrt(stepDiff));
  
  gl_FragColor = vec4(stepCol,1);
}