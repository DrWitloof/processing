PVector location;
PShape triple_loop;

float SCALE;
static int total_steps = 300;

color color_background, color_line, color_text;

void setup()
{
  size(600,600, P3D);
  SCALE = float(width)/2;
  
  color_background = color(189, 178, 255); // maximum blue purple
  color_background = color(55,77,66);
  color_line = color(255, 255, 252); // baby powder
  color_text = color(202, 255, 191); // tea green
  // color(255, 214, 165); // deep champagne
  // color_text = color(255, 173, 173); // light pink
  
  calculate_triple_loop();
}

void draw()
{
  background(color_background);
  stroke(color_line);
  
  pushMatrix();

  translate(width/2,height/2);
  shape(triple_loop, 0, 0);

  PVector loc1 = osc_v(frameCount, 1, 0.4, PI/3);
  PVector loc2 = loc1.copy().add(osc_v(frameCount, 4, 0.5, 0.0));

  stroke(color_line);
  line( 0, 0, SCALE*loc1.x, SCALE*loc1.y);
  line( SCALE*loc1.x, SCALE*loc1.y, SCALE*loc2.x, SCALE*loc2.y);

  stroke(color_text);
  circle(0,0,3);
  circle(SCALE*loc1.x, SCALE*loc1.y,3);
  circle(SCALE*loc2.x, SCALE*loc2.y,3);

  popMatrix();
  
    if (frameCount < total_steps) {
      saveFrame("output/gif-"+nf(frameCount, 3)+".png");
    }

}

PVector osc_v( int step, int freq, float a, float phi_offset)
{
  int steps = total_steps/freq;
  float phi = phi_offset +  2*PI * float(step%steps) / steps;
  return new PVector( a*sin(phi), a*cos(phi));
}

void calculate_triple_loop()
{
  triple_loop = createShape();
  triple_loop.beginShape();
  triple_loop.noFill();
  triple_loop.stroke(color_line);

  for( int i = 0; i<total_steps; i++) 
  {
    location = osc_v(i, 1, 0.4, PI/3).add(osc_v(i, 4, 0.5, 0.0));//.add(osc(i, 500, 0.02,0.02));
    triple_loop.vertex(SCALE*location.x, SCALE*location.y);
    if( i%50 == 0) { println(i); println(location); }
  }
  
  triple_loop.endShape(CLOSE);
}
