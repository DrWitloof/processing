// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

Mover[] movers = new Mover[20];
Path path;

float g = 0.4;

void setup() 
{
  size(600,600,P2D);
  
  path = new Path();
  
  for (int i = 0; i < movers.length; i++) {
    movers[i] = new Mover(random(0.2,1.7),random(width),random(height)); 
  }
}

void draw() {
  background(color(55,77,66));
  background(color(77,99,88));

  path.update();
  path.display();
  
  for (int i = 0; i < movers.length; i++) {
    for (int j = 0; j < movers.length; j++) {
      if (i != j) {
        PVector force = movers[j].attract(movers[i]);
        movers[i].applyForce(force);
      }
    }
    
    PVector force = path.attract(movers[i]);
    movers[i].applyForce(force);

    movers[i].update();
    movers[i].display();
  }



}
