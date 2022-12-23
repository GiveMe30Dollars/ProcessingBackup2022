class FieldSystem{
  ArrayList<Charge> poles;
  ArrayList<Charge> particles;
  FieldSystem(){
    poles = new ArrayList<Charge>();
    particles = new ArrayList<Charge>();
  }
  void addPole(Charge c){
    poles.add(c);
  }
  void addPole(float x, float y, float c){
    addPole(new Charge(x,y,c));
  }
  void addParticle(Charge c){
    particles.add(c);
  }
  void addParticle(float x, float y, float c){
    addParticle(new Charge(x,y,c));
  }
  
  PVector evaluate(Charge candidate){
    PVector output = new PVector(0,0);
    for (Charge  i : poles){
      PVector displacement = new PVector(candidate.x-i.x, candidate.y-i.y);
      output.add(displacement.div(pow(displacement.mag(),3)).mult(i.c));
    }
    output.mult(candidate.c);
    return output;
  }
  PVector evaluate(float x, float y, float c){
    return evaluate(new Charge(x,y,c));
  }
  PVector evaluate(float x, float y){
    return evaluate(new Charge(x,y,1));
  }
  
  void update(){
    for (Charge particle : particles){
      PVector force = evaluate(particle);
      force.rotate(HALF_PI);
      particle.update(force);
    }
  }
  
  void purge(float d){
    for (int i = particles.size()-1 ; i >= 0 ; i--){
      Charge p = particles.get(i);
      if (p.x < 0 || p.x > width || p.y < 0 || p.y > height){
        particles.remove(i);
        continue;
      }
      if (frameCount - p.spawnFrame > 200){
        particles.remove(i);
        continue;
      }
      for (Charge c : poles){
        if (Math.signum(p.c) == Math.signum(c.c)) continue;
        float distanceSq = pow(p.x-c.x,2) + pow(p.y-c.y,2);
        if (distanceSq <= d*d){
          particles.remove(i);
          break;
        }
      }
    }
  }
  
  void show(){
    for (Charge particle : particles){
      particle.show();
      
      //if (Math.signum(particle.c) > 0) particle.show(positive);
      //else particle.show(negative);
    }
  }
}
