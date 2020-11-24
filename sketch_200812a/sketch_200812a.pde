final color PAPER = color(85, 115, 200);
final color INK_ARM = color(240, 240, 240);
final color INK_CURVE = color(215, 175, 65);

final float ROTATION = PI/1000.0;

Arm myArm;
PGraphics myCurve;

void setup() {
  size(600, 600);

  init_curve();
  
  Arm a = myArm = createArm( width/3.0, height/2.0, width/5, 0, new OSC(0.05, 0.5));
  
  for( int i = 1; i<4; i++) 
  {
    a = createArm( a, i * width / 20, 0.5, new TURN(0.01*i));
  }
}

void draw() {
  update();

  init_draw();
  
  pushMatrix();
  rotate(-ROTATION*frameCount);
  translate(-width*2, -height*2);
  image(myCurve, 0, 0);
  popMatrix();

  myArm.draw();
}

void update() {
  myCurve.beginDraw();
  myCurve.translate(width*2, height*2);
  myCurve.rotate(ROTATION*frameCount);
  
  myArm.update();
  myCurve.endDraw();
}

void init_curve(){
  myCurve = createGraphics(width*4, height*4);
  
  myCurve.beginDraw();
  myCurve.background(PAPER);
  myCurve.noFill();
  myCurve.stroke(INK_CURVE);
  myCurve.strokeWeight(1);
  myCurve.translate(width*2, height*2);
  myCurve.endDraw();
}

void init_draw() {
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
      myCurve.ellipse(getEndX(), getEndY(), 1, 1);
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
