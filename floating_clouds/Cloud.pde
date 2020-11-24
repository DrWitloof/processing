class Cloud 
{
  ArrayList<CloudParticle> particles = new ArrayList<CloudParticle>();
  PShape particleShape;
  
  PVector position;
  PVector speed;
  color clr;

  Cloud( float x, float y) { 
    this(x, y, color(255, 12), new PVector(1,0));
  }

  Cloud( float x, float y, PVector speed) { 
    this(x, y, color(255, 12), speed);
  }
  
  Cloud(float x, float y, color clr, PVector speed)
  {
    fill(clr);
    this.particleShape = createShape(GROUP);
    this.position = new PVector( x, y);
    this.speed = speed;
    this.addParticles( 0, 0, 44);
    this.clr = clr;
  }

  private void addParticles(float x, float y, float w)
  {
    CloudParticle p = new CloudParticle(x, y, w, this);
    particles.add(p);
    particleShape.addChild(p.getShape());

    if ( w > 1)
      for (int i = 0; i < 2; i++)
      {
        this.addParticles(
          x + random(-w, w), 
          y + random(-w/2, w/4), 
          max(1.0, w - random(10)));
      }
  }

  float particle_offset = 0.0;
  
  void update()
  {
    particleShape.translate(speed.x, speed.y);
    
    float _particle_offset = particle_offset;
    
    for (CloudParticle p : particles) 
    {
      p.update();
      particle_offset += 0.0007;
    }
    
    particle_offset = _particle_offset + 0.003;

    position.add(speed);
  }

  void display()
  {
   // fill(clr, o);
    shape(particleShape);
  }
}


class CloudParticle
{
  PVector position;
  PVector reference_position;
  float size;
  color clr;
  Cloud cloud;
  PShape part;

  CloudParticle(float x, float y, float size, Cloud cloud)
  {
    this.position = new PVector(cloud.position.x + x, cloud.position.y + y);
    this.reference_position = position.copy();
    this.size = size;
    this.cloud = cloud;

    //fill(cloud.clr);
    part = createShape(ELLIPSE, cloud.position.x + x, cloud.position.y + y, size, size);
    //part.setFill(cloud.clr);
    //part.setStrokeWeight(0);
    //part.setFill(color(cloud.o));
    
  }
  
  void update() {
    position.add( cloud.speed);

    reference_position.add( cloud.speed);
    
    PVector translation = reference_position.copy()
                            .add(50*noise(cloud.particle_offset), 30*noise(cloud.particle_offset+1000))
                            .sub(position);
    
    part.translate( translation.x, translation.y);        
    position.add( translation);
    
    wrap();
  }
  
  void display() {
  }
  
  PShape getShape() { return part; }

  
  void wrap()
  {
    PVector translation = new PVector(position.x%width, position.y%height)
                            .sub(position);
    
    if( translation.magSq() > 0) 
    {
      part.translate(translation.x, translation.y);        
      position.add(translation);
      reference_position.add(translation);
    }
  }
}
