Spot[] spots; // Declare array
void setup() {
  size(700, 100);
  initspots();
  noStroke();
}

void initspots()
{
  int numSpots = 70; // Number of objects
  int dia = width/numSpots; // Calculate diameter
  spots = new Spot[numSpots]; // Create array
  for (int i = 0; i < spots.length; i++) {
    float x = dia/2 + i*dia;
    float rate = (int(random(.1, 2.0))==1?1:-1)*random(0.1, 2.0);
    float y = random(dia/2, height-dia/2);
    // Create each object
    spots[i] = new Spot(x, y, dia, rate*(height/100));
  }
}

void draw() {
  fill(0, 12);
  rect(0, 0, width, height);
  fill(255);
  for (int i=0; i < spots.length; i++) {
    spots[i].move(); // Move each object
    spots[i].display(); // Display each object
  }
}

void keyPressed()
{ 
  initspots();
}

class Spot {
  float x, y;         // X-coordinate, y-coordinate
  float diameter;     // Diameter of the circle
  float speed;        // Distance moved each frame
  int direction = 1;  // Direction of motion (1 is down, -1 is up)
  
  // Constructor
  Spot(float xpos, float ypos, float dia, float sp) {
    init( xpos,  ypos,  dia,  sp );
  }
  
  void init( float xpos, float ypos, float dia, float sp) {
    x = xpos;
    y = ypos;
    diameter = dia;
    speed = sp;
  }
    
  void move() {
    y += (speed * direction); 
    if ((y > (height - diameter/2)) || (y < diameter/2)) { 
      direction *= -1; 
    } 
  }
  
  void display() {
    ellipse(x, y, diameter, diameter);
  }
}
