OpenSimplexNoise noise;

int cols, rows;
int scl = 30;

int w = 2500, h = 2000;
float[][] terrain;
float flying;

void setup()
{
  size( 600, 600, P3D);
  
  cols = w/scl;
  rows = h/scl;
  
  terrain = new float[cols][rows];
  noise = new OpenSimplexNoise();
}

int numFrames = 75;
 
float radius = 1.0;

void draw()
{
  float t = 1.0*frameCount/numFrames;
  
  float offy = 0;
  for( int y=0; y<rows-1; y++) {
    float offx = 0;
    for( int x=0; x<cols; x++) {
      float noise_val = (float)noise.eval( 
      terrain[x][y] = map( noise(offx,offy), 0,1, -100, 100);
      offx += 0.1;
    }
    offy += 0.1;
  }

  
  background(51);
  
  translate(width/2, height/2);
  rotateX(10*PI/30);

  translate(-w/2, -h/2 - 500);
  for( int y=0; y<rows-1; y++) {
    stroke(255);
    fill(255*(1-((float)y/rows)));
    beginShape(TRIANGLE_STRIP);
    for( int x=0; x<cols; x++) {
      vertex(x*scl, y*scl, terrain[x][y]);
      vertex(x*scl, (y+1)*scl, terrain[x][y+1]);
    }
    endShape();
  }
}
