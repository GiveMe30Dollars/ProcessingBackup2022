#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_COLOR_SHADER

uniform vec2 resolution;
uniform vec2 lightPosition;
uniform float reach;


float smin(float a, float b, float k){
  float h = clamp( 0.5+0.5*(b-a)/k, 0.0, 1.0 );
  return mix( b, a, h ) - k*h*(1.0-h);
}
float smin(float a, float b){
  return smin(a,b,0.1);
}



void main(){
  vec2 displacement = gl_FragCoord.xy/resolution - lightPosition/resolution;
  float mag = length(displacement);
  float illumination = min(reach/mag,1);
  gl_FragColor = vec4(vec3(illumination),1);
}