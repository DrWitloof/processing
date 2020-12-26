
class Path
{
  PShape path;
  
  
  
  Path()
  {
    int SCALE = 200;
    
    PVector mid = new PVector(width/2, height/2);
    
    path = createShape();
    path.beginShape();
    path.noFill();
    path.stroke(color(255, 255, 252));
  
    for( int i = 0; i<total_steps; i++) 
    {
      PVector location = osc_v(i, 1, 0.4, PI/3).add(osc_v(i, 4, 0.5, 0.0)).mult(SCALE).add(mid);//.add(osc(i, 500, 0.02,0.02));
      path.vertex(location.x, location.y);
      if( i%50 == 0) { println(i); println(location); }
    }
    
    path.endShape(CLOSE);
  }
  
  int total_steps = 1000;
  
  PVector osc_v( int step, int freq, float a, float phi_offset)
  {
    int steps = total_steps/freq;
    float phi = phi_offset +  2.0*PI * float(step%steps) / steps;
    return new PVector( a*sin(phi), a*cos(phi));
  }
  
  void update()
  {
  }
  
  void display()
  {
   // shape(path, 0, 0);
  }
  
  PVector attract(Mover m)
  {
    int closest_i = 0;
    float closest_dist = 999999.0;
    
    for( int i = 0; i<path.getVertexCount(); i+=1) 
    {
      if( path.getVertex(i).dist( m.position) < closest_dist)
      {
        closest_i = i;
        closest_dist = path.getVertex(i).dist( m.position);
      }
    }
    
    PVector closest_point = path.getVertex(closest_i);
    PVector next_closest_point = path.getVertex((closest_i+1)%path.getVertexCount());

    PVector force = PVector.sub(closest_point, m.position).add(PVector.sub(closest_point, next_closest_point).mult(0.3)).mult(0.5);    
    float dist = force.mag();                                 
    dist = constrain(dist, 5.0, 25.0) * 10;                            
    //force.normalize();  
    force.limit(0.2);

    // float strength = (g  * m.mass); // / dist; 
    // force.mult(strength);  
    //force.rotate(map(dist_sq, 25.0, 625.0, HALF_PI, 0.0));
    return force;
    
  //  if( closest_dist < 30) 
  //    return PVector.sub(path.getVertex(closest_i), m.position).normalize().mult(0.1).rotate(HALF_PI);
  //  return PVector.sub(path.getVertex(closest_i), m.position).normalize().mult(0.1);
  }
}
