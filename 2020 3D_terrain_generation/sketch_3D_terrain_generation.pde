int cols, rows;
int scl = 20;

int w = 2000, h = 2000;
float[][] terrain;
float flying;

color fill_color_from = color(50, 168, 74);
color fill_color_to = color(3, 59, 14);
color line_color = color(255);
color back_color = color(5, 215, 242);

void setup()
{
  size( 600, 600, P3D);
  
  cols = w/scl;
  rows = h/scl;
  
  terrain = new float[cols][rows];

}

void draw()
{
  flying -= 0.1;
  
  float offy = flying;
  for( int y=0; y<rows-1; y++) {
   float offx = 0;
   for( int x=0; x<cols; x++) {
      terrain[x][y] = map( noise(offx,offy), 0,1, -100, 100);
      offx += 0.1;
    }
    offy += 0.05;
  }

  background(back_color);
  
  translate(width/2, height/2);
  rotateX(160*PI/360);
  
  // color : 50, 168, 74

  translate(-w/2, -h/2-200);
  for( int y=0; y<rows-1; y++) {
    stroke(line_color);
    
    fill(lerpColor(fill_color_from, fill_color_to, ((float)y)/(float)rows));
    
    //fill(255*(1-((float)y/rows)));
    beginShape(TRIANGLE_STRIP);
    for( int x=1; x<cols; x++) {
        vertex(x*scl, y*scl, terrain[x][y]);
        vertex(x*scl, (y+1)*scl, terrain[x][y+1]);
/*      if(y%2==0) {
        vertex(x*scl , y*scl, terrain[x][y]);
        vertex(x*scl + scl/2, (y+1)*scl, terrain[x][y+1]);
      } else {
        vertex(x*scl - scl/2, y*scl, terrain[x-1][y]);
        vertex(x*scl, (y+1)*scl, terrain[x][y+1]);
      }
*/    }
    endShape();
  }
}
