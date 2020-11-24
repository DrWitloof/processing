final color PAPER = color(85, 115, 200);
final color INK_ARM = color(240, 240, 240);
final color INK_CURVE = color(215, 175, 65);

final int MINI_SIZE = 4;

final int CURVE_STROKE_WIDTH = 2; 
final float CURVE_RATIO = sqrt(2);

final float STEPS = 1000.0;
final float ROTATION = PI/STEPS;


String message = "";

Arm myArm;
PGraphics myCurve;

void setup() {
  size(600, 600);

  setup_curve();
  setup_arm();
}

void setup_curve(){
  myCurve = createGraphics(int(width*CURVE_RATIO*2), int(height*CURVE_RATIO*2));
  
  myCurve.beginDraw();
  myCurve.background(PAPER);
  myCurve.noFill();
  myCurve.stroke(INK_CURVE);
  myCurve.strokeWeight(1);
//  myCurve.translate(width*2, height*2);
  myCurve.endDraw();
}

void setup_arm()
{
  Arm a = myArm = createArm( width/3.0, height/2.0, width/5, 0, new OSC(0.05, 0.5));
  
  for( int i = 1; i<4; i++) 
  {
    a = createArm( a, i * width / 20, 0.5, new TURN(0.01*i));
  }
}

void draw() {
  update();

  draw_prep();
  
/*
  pushMatrix();
  rotate(-ROTATION*frameCount);
  translate(-myCurve.width/2, -myCurve.height/2);
  image(myCurve, 0, 0);
  popMatrix();
*/

//  fill(102);
//  rect( width-(width/MINI_SIZE)-4, height-(height/MINI_SIZE)-4, width/MINI_SIZE, height/MINI_SIZE);
//  image(myCurve, width-(width/MINI_SIZE), height-(height/MINI_SIZE), width/MINI_SIZE, height/MINI_SIZE);  

  image(myCurve, 0, 0, width, height);   
  
  myArm.draw();
  
  text(str(frameRate), 10, 10);
  text(message, 10, 20);
  text(frameCount, 10, 30);
}

void update() {
  myCurve.beginDraw();
  myCurve.translate(myCurve.width/2, myCurve.height/2);
  myCurve.rotate(ROTATION*frameCount);
  
  myArm.update();
  myCurve.endDraw();
}


void draw_prep() {
  float s = min(width, height) / 100; 
  //translate(width/3.0, height/2.0);
  background(0);
  stroke(INK_ARM);
  strokeWeight(s);
}

Arm createArm( float x, float y, float l, float a, ArmUpdater u) { return new Arm( x, y, l, a, u); }
Arm createArm( Arm linkingFrom, float l, float a, ArmUpdater u) { Arm la = new Arm( linkingFrom.getEndX(), linkingFrom.getEndY(), l, a, u); linkingFrom.link(la); return la; }

class Arm
{
  public float x, y, l, ia, sa, oa, a; // x-pos, y-pos, length, initial angle, systems angle, offset angle (calculated), final angle
  public ArmUpdater u;
  public Arm linkedArm;
  
  Arm(float x, float y, float l, float a, ArmUpdater u) 
    { doPosition( x, y, 0); this.l = l; this.ia = this.a = a; this.u = u; }
    
  void doPosition( float x, float y, float sa) { this.x = x; this.y = y; this.sa = sa; }
  void link( Arm linkedArm) { this.linkedArm = linkedArm; linkedArm.doPosition(getEndX(), getEndY(), this.a); }
    
  float getEndX() { return this.x + cos(this.a)*this.l; }
  float getEndY() { return this.y + sin(this.a)*this.l; }
  
  void update() { 
    u.update(this); 
    a = sa + ia + oa; 
    if( linkedArm != null) { 
      linkedArm.doPosition(getEndX(), getEndY(), a); 
      linkedArm.update(); 
    } else {
//      myCurve.beginDraw();
      myCurve.ellipse(getEndX(), getEndY(), CURVE_STROKE_WIDTH, CURVE_STROKE_WIDTH);
//      myCurve.endDraw();
    }
  }
  
  void draw() { 
    line( this.x, this.y, getEndX(), getEndY()); 
    if( linkedArm != null) 
      linkedArm.draw();
  }
}

abstract class ArmUpdater { abstract void update( Arm a); }
class OSC extends ArmUpdater { OSC( float speed, float max) { this.speed = speed; this.max = max; } float speed, max; int cnt=0; void update( Arm a) { a.oa = (max * sin(speed * cnt++)); } }
class TURN extends ArmUpdater { TURN( float speed) { this.speed = speed; } float speed; int cnt=0; void update( Arm a) { a.oa = speed * cnt++; } }

void keyPressed() {
  String date_time = year() + nf(month(),2) + nf(day(),2) + " " +  nf(hour(), 2) + "h" + nf(minute(), 2) + "m" + nf(second(), 2) + "s";
  myCurve.save("myCurve " + date_time + ".png");
  message = "printed at " + date_time;
}
