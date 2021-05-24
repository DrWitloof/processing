//float osc( int t, int A, int k, int m, float fi) { return A * cos(sqrt(1.0 * k / m)*t + fi); }
float osc( int t, int A, float f, float fi) {   return A * cos(TWO_PI*t/f + fi);  }

color colors[] = {  
                  color(206, 129, 71),
                  color(236, 221, 123),
                  color(211, 226, 152),
                 // color(205, 231, 190) 
                };
                  
int color_i = 0;
                  
color bgcolor = color(86, 29, 37);

void setup()
{
  size(1000,1000);
  //frameRate(10.0);
  set_color();
}

float size, size2, size3;

void draw()
{
  background(bgcolor);
  
  float size = osc( frameCount, width/4, 100, HALF_PI);
  
  if( abs(size) > abs(size2) & abs(size2) < abs(size3)) { 
    //random(colors.length()),
    set_color();
    println(frameCount);
  }
  
  size3 = size2;
  size2 = size;
  
  strokeWeight(abs(size)/8);
  
  circle(
    width/2 + osc( frameCount, width/3, 100, HALF_PI), 
    width/2 + osc( frameCount, width/3, 200, 0.0), 
              size);
               
 // if( frameCount < 1000) { saveFrame("frames/####.png"); }
}

void set_color()
{
  color_i = (color_i+1)%colors.length;
  fill(colors[color_i]);
  stroke(colors[(color_i+1)%colors.length]);
}
