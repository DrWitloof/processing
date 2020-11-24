
Car mycar;

void setup() {
  size(200,200);
  mycar = new Car();
}

void draw() {
  background(255);
  mycar.move();
  mycar.display();
}

class Car {

  color c ;
  float speed ;
  int blockwidth ;
  float x ;
  float y ;
  
  Car() {
    c = color(0);
    speed = 3;
    blockwidth = 50;
    x = 0;
    y = 100;
  }
  
  void move() {
    x = x + speed;
    if (x > width) {
      x = 0;
    }
  }
  
  void display() {
    fill(c);
    rect(x,y,blockwidth,10);
    if( x > width-blockwidth) rect(0,y,x+blockwidth-width,10);
  }
}
