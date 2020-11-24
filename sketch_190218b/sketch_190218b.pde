//PFont sourceLight;

  
float rectSize = 100;                                   //  4
PFont zigBlack;

float rectAngle = 0;
int x, y;
color c = color(255);                                   //  5
color bg = color(78, 93, 75);                           //  6


void setup()
{
  size(500, 300);

  zigBlack = createFont("Ziggurat-Black", 32);
  textFont(zigBlack);

  textSize(55);
  textLeading(35);
  textAlign(RIGHT, BOTTOM);
  rectMode(CENTER);
  noStroke();

  x = width/2;                                          //  8
  y = height/2;                                         //  9
}

void draw()
{
  rectSize = 2* dist(x,y,mouseX, mouseY);
  float pct = rectSize/100;
  background(bg);
  pushMatrix();                                         //  10
  translate(x, y);                                      //  11
  rotate(rectAngle);
  fill(c);
  rect(0, 0, rectSize, rectSize);
  // textSize(40); // Set text size to 32
  textSize(60*pct); 
//  textLeading(40*pct);
  fill(0);
  text("Stu", 0, -40*pct, 110*pct, 80*pct);
  text("Bru", 0, -10*pct, 110*pct, 120*pct);
  popMatrix();                                          //  12
}

  
