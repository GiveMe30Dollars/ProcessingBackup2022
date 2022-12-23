class Bulb{
  
  ArrayList<Particle> particles = new ArrayList<Particle>();
  PVector position;
  float radius;
  int seed;
  
  Bulb(float x, float y, float r, int s, float d){
    position = new PVector(x,y);
    radius = r;
    seed = s;
    float density = 2*PI*r/(d);
    SpawnParticles((int)density);
  }
  
  void SpawnParticles(float density){
    for (int i = 0; i < density; i++){
      float angle = i*2*PI/density;
      PVector particlePos = PVector.fromAngle(angle).mult(radius).add(position);
      particles.add(new Particle(particlePos.x, particlePos.y, seed));
    }
  }
  
  void Update(){
    for (int i = 0; i < particles.size(); i++){
      Particle particle = particles.get(i);
      particle.Update();
      if (particle.IsOutOfBounds()) {
        particles.remove(i);
        i--;
      }
    } 
  }
  
  void DrawCircle(){
    circle(position.x, position.y, radius*2);
  }
  
  boolean IsOutOfBounds(){
    if (particles.size()==0){
      return true;
    }
    return false;
  }
}
